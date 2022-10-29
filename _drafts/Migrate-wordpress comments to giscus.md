---
title: Migrate WordPress comments to Giscus
---


## Migrate

- GraphQL explorer (https://docs.github.com/en/graphql/overview/explorer) + sign in

- List discussions & comments 


{
  repository(owner: "rpeyron", name: "test") {
    discussions(first: 10) {
      totalCount
      pageInfo {
        startCursor
        endCursor
        hasNextPage
        hasPreviousPage
      }
      nodes {
        title
        body
        author {
          login
        }
        category {
          id
        }
        comments(first: 10) {
          totalCount
          nodes {
            author {
              login
            }
            body
            editor {
              login
            }
            replyTo {
              id
            }
          }
        }
      }
    }
  }
}

- Add discussion & comments

mutation MyMutation {
  addDiscussionComment(input: {discussionId: "", body: ""})
  createDiscussion(input: {repositoryId: "", title: "", body: "", categoryId: ""}) {
    discussion {
      comments {
        nodes {
          body
          author
        }
      }
    }
  }
}

mutation MyMutation { createDiscussion(input: {repositoryId: "R_kgDOILz3hw", title: "Test GraphQL 2", body: "Test", categoryId: "DIC_kwDOILz3h84CR6Hr"}) { discussion {  id  } } }

https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions

https://spec.graphql.org/October2021/#sec-Coercing-Variable-Values

D_kwDOILz3h84ARE0a

mutation MyMutation {
  addDiscussionComment(
    input: {discussionId: "D_kwDOILz3h84ARE0a", body: "reponse", replyToId: "DC_kwDOILz3h84AO1WQ"}
  ) {
    comment {
      id
    }
  }
}


Auth with gh & get token with gh auth token

