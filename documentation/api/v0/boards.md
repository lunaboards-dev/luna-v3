# /api/v0/boards
This simply gets all the viewable boards on Luna. It returns an array.

## Arguments
None

## Board Info Structure
| Name | Type | Example | Notes |
| --- |  --- | --- | --- |
| `name` | string | `"Random"` |  |
| `id` | string | `"l"` |  |
| `textonly` | boolean | `false` |  |
| `thread_count` | integer | `2` |  |

## Example
```json
	[
		{
			"name": "Random",
			"id": "l",
			"textonly": false,
			"thread_count": 2
		},
		{
			"name": "Creative",
			"id": "u",
			"textonly": false,
			"thread_count": 0
		}
	]
```
