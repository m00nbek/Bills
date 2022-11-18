# Bills


## Expense Feed Feature Specs

### Story: Customer requests to see their Expense feed

### Narrative #1

```
As an online customer
I want the app to automatically load my expenses feed
So I can see my expenses
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see their feed
 Then the app should display the feed from remote
  And replace the cache with the new feed
```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved version of my expenses feed
So I can see my expenses
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And there’s a cached version of the feed
  And the cache is less than seven days old
 When the customer requests to see the feed
 Then the app should display the latest feed saved

Given the customer doesn't have connectivity
  And there’s a cached version of the feed
  And the cache is seven days old or more
 When the customer requests to see the feed
 Then the app should display an error message

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the feed
 Then the app should display an error message
```

## Use Cases

### Load Feed From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Expenses Feed" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates expenses feed from valid data.
5. System delivers expenses feed.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Feed Expenses Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Expenses Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers expenses data.

#### Cancel course:
1. System does not deliver expenses data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Feed From Cache Use Case

#### Primary course:
1. Execute "Load Expenses Feed" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.
4. System creates expenses feed from cached data.
5. System delivers expenses feed.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no feed expenses.

#### Empty cache course (sad path): 
1. System delivers no feed expenses.

---

### Load Feed Expenses Data From Cache Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Expenses Data" command with above data.
2. System retrieves data from the cache.
3. System delivers cached expenses data.

#### Cancel course:
1. System does not deliver expenses data nor error.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Validate Feed Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache Feed Use Case

#### Data:
- Expenses Feed

#### Primary course (happy path):
1. Execute "Save Expenses Feed" command with above data.
2. System deletes old cache data.
3. System encodes expenses feed.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Cache Feed Expenses Data Use Case

#### Data:
- Expenses Data

#### Primary course (happy path):
1. Execute "Save Expenses Data" command with above data.
2. System caches expenses data.
3. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

---

## Flowchart

[//]: # (![Feed Loading Feature](feed_flowchart.png))

## Model Specs

### Feed Expense

| Property      | Type                    |
|---------------|-------------------------|
| `id`          | `UUID`                  |
| `title`       | `String`                |
| `timestamp`   | `Date` (ISO8601 String) |
| `cost`        | `Float`                 |
| `currency`    | `String`                |

### Payload contract

```
GET /feed

200 RESPONSE

{
	"items": [
		{
			"id": "a UUID",
			"title": "a title",
			"timestamp": "2022-11-18 06:20:17+0000",
			"cost": "45.3",
			"currency: "USD"
		},
		{
			"id": "another UUID",
			"title": "another title",
			"timestamp": "2022-11-18 06:20:20+0000",
			"cost": "23000",
			"currency: "UZS"
		},
		...
	]
}
```
---
