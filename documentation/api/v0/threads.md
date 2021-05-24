# /api/v0/threads
This gets all the threads on a board. It returns an array.

## Arguments
| Name | Example | Info |
| --- | --- | --- | --- |
| `board` | `l` | The board ID to get thread listing from. Optional. Defaults to `all` |

## Thread Info Structure
| Name | Type | Example | Notes |
| --- | --- | --- | --- |
| `id` | string | `"905887ca5a89"` | This is a hex string, not an integer! |
| `op` | object |   | See OP structure below. |
| `name` | string | `"holy shit i think it works"` |  |
| `locked` | boolean | `false` |  |
| `created` | string | `"2021-05-16 01:28:42"` | Postgres UTC timestamp. |
| `last_update` | string | `"2021-05-21 22:05:36"` | Postgres UTC timestamp. |
| `marked` | boolean | `false` | Tells if marked for deletion. Basically locking but with the bonus of deleting the thread in the next thread-gc cycle. Don't expect to see this set to true too often. |
| `pinned` | integer | `0` | Pin level. Higher value = Higher up on the list. |
| `posts` | integer | `6` |  |
| `board` | string | `"l"` |   |
| `ip` | string |   | Only present if authenticated an admin and they have the view IP permission for the board. |

## OP structure
| Name | Type | Example | Notes |
| --- | --- | --- | --- |
| `trip` | string | `"1e35b3295d9"` | The funky text that identifies a poster in that thread, or across the board if it's a custom tripcode. |
| `content` | string | `"awoo"` |  |
| `picture` | string | `"2324ac96-f3e4-45ac-9eb7-710b2c3cb1c9"` | The UUID of the image. Use the files API to get the path of the image. May not be present if there's no image on the original post. |
| `date` | string | `"2021-05-16 06:43:03"` | Postgres UTC timestamp. |
| `original_name` | string | `"kageroo_shake.gif"` | Original filename. May not be present if there's no image on the original post. |
| `ip` | string |   | Only present if authenticated an admin and they have the view IP permission for the board. |

## Example
```json
[
  {
    "id": "905887ca5a89",
    "op": {
      "trip": "de9a259fe75",
      "content": "fuck yeah",
      "date": "2021-05-16 01:28:42"
    },
    "name": "holy shit i think it works",
    "locked": false,
    "created": "2021-05-16 01:28:42",
    "last_update": "2021-05-21 22:05:36",
    "marked": false,
    "pinned": 0,
    "posts": 6,
    "board": "l"
  },
  {
    "id": "57d44b1d2ab4",
    "op": {
      "trip": "1e35b3295d9",
      "content": "awoo",
      "picture": "2324ac96-f3e4-45ac-9eb7-710b2c3cb1c9",
      "date": "2021-05-16 06:43:03",
      "original_name": "kageroo_shake.gif"
    },
    "name": "test",
    "locked": false,
    "created": "2021-05-16 06:43:03",
    "last_update": "2021-05-19 00:47:58",
    "marked": false,
    "pinned": 0,
    "posts": 5,
    "board": "l"
  }
]
```
