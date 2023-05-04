import requests
import json
import logging


def fetch_playlist_items_page(google_api_key, youtube_playlist_id, page_token=None):
    """
    This function gets the videos' data of a playlist.

    :param google_api_key: Api which enables the fetching.
    :param youtube_playlist_id: id of the YouTube playlist.
    :param page_token: Token that tells us which page we currently are.
    :return: A json structure with the page data.
    """

    response = requests.get("https://www.googleapis.com/youtube/v3/playlistItems",
                            params={
                                "key": google_api_key,
                                "playlistId": youtube_playlist_id,
                                "part": "contentDetails",
                                "pageToken": page_token
                            })

    payload = json.loads(response.text)

    logging.debug("GOT %s", payload)

    return payload


def fetch_playlist_items(google_api_key, youtube_playlist_id, page_token=None):
    """
    This function uses fetch_playlist_items_page to get the page's data. But, because YouTube
    retrieves only 5 videos' data, then it's necessary to go to another page and get the data.
    So, seeing if in the actual page exists a next_page_token, it will call another
    fetch_playlist_items_page for the next page.

    :param google_api_key: Api which enables the fetching
    :param youtube_playlist_id: id of the YouTube playlist
    :param page_token: Token that tells us which page we currently are
    """

    payload = fetch_playlist_items_page(google_api_key, youtube_playlist_id, page_token)

    yield from payload["items"]

    next_page_token = payload.get("nextPageToken")

    if next_page_token is not None:

        yield from fetch_playlist_items(google_api_key, youtube_playlist_id, next_page_token)
