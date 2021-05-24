# Luna API v0
lua may use 1-based indexes but luna's api versioning sure doesn't

## Methods
[boards](boards.md)(`/api/v0/boards`) - Get board listing

[threads](threads.md)(`/api/v0/threads?board=x`) - Get thread listing of board

[posts](posts.md)(`/api/v0/posts?board=x&thread=y`) - Get posts on thread

[files](files.md)(`/api/v0/files?uuid=x` or `/api/v0/files?hash=x`) - Get file info and references
