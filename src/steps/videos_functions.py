import requests
import logging
import json

from src.steps.items_functions import fetch_playlist_items


def fetch_videos_page(google_api_key, video_id, page_token=None):
    """
    This function retrieves the statistical data of a specific video.

    :param google_api_key: Api which enables the fetching.
    :param video_id: ID of a specific video.
    :param page_token: Token that tells us which page we currently are.

    :return: A json structure, which caintains the data about the video's statistics.
    """

    response = requests.get("https://www.googleapis.com/youtube/v3/videos",
                            params={
                                "key": google_api_key,
                                "id": video_id,
                                "part": "snippet,statistics",
                                "pageToken": page_token
                            })

    payload = json.loads(response.text)

    logging.debug("GOT %s", payload)

    return payload


def fetch_videos(google_api_key, video_id, page_token=None):
    """
    This function gets the statistical data of every video in a playlist
    page by calling fetch_videos_page.
    If exists a next page, it will call again fetch_videos_page, until there are
    no other pages.

    :param google_api_key: Api which enables the fetching.
    :param video_id: ID of a specific video.
    :param page_token: Token that tells us which page we currently are.
    """

    payload = fetch_videos_page(google_api_key, video_id, page_token)

    yield from payload["items"]

    next_page_token = payload.get("nextPageToken")

    if next_page_token is not None:

        yield from fetch_playlist_items(google_api_key, video_id, next_page_token)


def sumarize_video(video):
    """
    This function gets a dictionary, which contains the video's wanted data.

    :param video: The json data of a video.

    :return: Dictionary with the data.
    """

    return {
        'video_id': video['id'],
        'video_title': video['snippet']['title'],
        'views': int(video['statistics'].get('viewCount', 0)),
        'likes': int(video['statistics'].get('likeCount', 0)),
        'comments': int(video['statistics'].get('commentCount', 0))

    }
