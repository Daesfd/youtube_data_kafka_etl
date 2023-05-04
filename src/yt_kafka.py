import sys

from config import config
from pprint import pformat

from src.steps.videos_functions import *

from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.serialization import StringSerializer
from confluent_kafka.schema_registry.avro import AvroSerializer
from confluent_kafka import SerializingProducer


def on_delivery(err, record):

    if err is not None:
        print(f'Falha ao enviar: {err}')

    else:
        print(f'Mensagem enviada à {record.topic}, {record.partition}')


def main():

    logging.info('START')

    schema_registry_client = SchemaRegistryClient(config["schema_registry"])
    youtube_videos_value_schema = schema_registry_client.get_latest_version("data_ingestion_topic-value")

    kafka_config = config["src"] | {
        "key.serializer": StringSerializer(),
        "value.serializer": AvroSerializer(
            schema_registry_client,
            youtube_videos_value_schema.schema.schema_str,
        ),
    }

    producer = SerializingProducer(kafka_config)

    google_api_key = config['google_api_key']
    youtube_playlist_id = config['youtube_playlist_id']

    # Here, it gets every video's, from a YouTube playlist, data and, from it, gets the id of the video.
    for video_item in fetch_playlist_items(google_api_key, youtube_playlist_id):

        video_id = video_item['contentDetails']['videoId']

        # Then, with the id, it gets the wanted data from each video from the playlist.
        for video in fetch_videos(google_api_key, video_id):

            logging.info('GOT %s', pformat(sumarize_video(video)))

            # Finally, it sends the data to the confluent cluster.
            producer.produce(
                topic="data_ingestion_topic",
                key=video_id,
                value={
                    "VIDEO_TITLE": video["snippet"]["title"],
                    "VIEWS": int(video["statistics"].get("viewCount", 0)),
                    "LIKES": int(video["statistics"].get("likeCount", 0)),
                    "COMMENTS": int(video["statistics"].get("commentCount", 0)),
                },
                on_delivery=on_delivery,
            )

    producer.flush()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    sys.exit(main())
