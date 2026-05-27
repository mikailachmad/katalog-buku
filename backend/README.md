# Get Started
## Environment Variable
Ensure you have required environment vairable:
- `PORT`
- `DB_URL` 
- `JWT_KEY` <br>
look at `.env_example`
## Database migration
`cd /backend/sql/schema` <br>
`goose postgres "user=<db-user> password=<your-password> host=<url> port=5432 dbname=bookshelf sslmode=disable" up`
## Parse SQL into type-safe and idiomatic code
`cd /backend` <br>
`sqlc generate`
## Build and Run Go server
`cd /backend` <br>
`go build` <br>
`./bookshelf`