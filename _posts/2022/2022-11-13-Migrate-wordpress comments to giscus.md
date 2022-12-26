---
title: Migrate WordPress comments to Giscus
toc: true
date: '2022-11-13 01:04:34'
tags:
- Jekyll
- GitHub
- Web
- Wordpress
- Migration
- Giscus
categories:
- Informatique
lang: en
image: files/2022/cms-265128_640.jpg
---

In [this post about my migration process to Jekyll]({{ '/2022/10/migrate-to-jekyll/#add-commenting-system-and-redirects' | relative_url }}) I explained the reasons that made me choose [Giscus](https://giscus.app) as commenting system. But unfortunately it does not come with a tool to migrate comments to GitHub. So I tried to make one.

Please note that we won't be able to migrate comments as they were originally made with Giscus, as original commenters may not have a GitHub account and even if they had one, we cannot impersonate them to post as they could have. So all posts will be from the username of the repository, with a mention saying that it is a migrated comment, the name of original author and the original date of the comment.

# How to post GitHub discussion via API
GitHub has a wide range of integration tools to interact with your GitHub data, among them:
- the `gh` command line tool
- a set of REST APIs
- a GraphQL API

Unfortunately, discussions are not yet available in the two first options, that may have been easier to deal with for me. So I had to discover GraphQL.


# In the GitHub GraphQL playground
GitHub integrates a [GraphQL explorer](https://docs.github.com/en/graphql/overview/explorer) that enables you to try directly some GraphQL requests after signing up with your GitHub account.

There is also [a guide to use GrphQL for discussions](https://docs.github.com/en/graphql/guides/using-the-graphql-api-for-discussions) and the [full reference](https://docs.github.com/en/graphql/reference/objects#discussion). 

The principle of GraphQL is very simple: you define a query, and then the data structure you want as a response.

Below is for instance a query to get first 10 discussions with 10 first  comments for each discussion on the GitHub repo rpeyron/test:

```graphql
{ repository(owner: "rpeyron", name: "rpeyron.github.io") {
    discussions(first: 10) {
      totalCount
      pageInfo { startCursor endCursor hasNextPage hasPreviousPage }
      nodes { title body  author { login}  category {  id }
        comments(first: 10) { totalCount  nodes {
            author { login }
            body
            editor { login  }
            replyTo {  id }
}}}}}}
```

That is nice, but what we want is to create discussion and comments. Modification queries are called 'mutation'. Below an example to create a discussion.

```graphql
mutation MyMutation {
  createDiscussion(input: {repositoryId: "", title: "", body: "", categoryId: ""}) {
    discussion { id }
} }
```

And for my repository:
```graphql
mutation MyMutation { 
  createDiscussion(input: {repositoryId: "R_kgDOILz3hw", title: "Test GraphQL 2", body: "Test", categoryId: "DIC_kwDOILz3h84CR6Hr"}) { 
	  discussion {  id  } 
} }
```

You will get the needed identifiers either via other GraphQL calls, or easier with [Giscus configuration](https://giscus.app) : you will find the identifier in the generated configuration.

Note that we ask the identifier of the created discussion in the response to be able to use it to create comments:
```graphql
mutation MyMutation {
  addDiscussionComment( input: {discussionId: "D_kwDOILz3h84ARE0a", body: "reponse", replyToId: "DC_kwDOILz3h84AO1WQ"}  ) {
    comment { id }
} }
```


# In PHP script
I modified the [wordpress-to-jekyll-exporter script](https://github.com/rpeyron/wordpress-to-jekyll-exporter) to export comments to GitHub.

I copied some code to forge GraphQL queries from [this gist](https://gist.github.com/dunglas/05d901cb7560d2667d999875322e690a). This function is the simplest one that I have found, far beyond other GraphQL libraries that seemed to me very complicated to use be someone like me that does not know well GraphQL. 

You will need a token to make these calls. It can be very easily retrieved with the [`gh` command line tool from GitHub](https://cli.github.com/) with:
```shell
gh auth login
gh auth token
```

<details markdown="1"><summary>Extracts of PHP source code</summary>
	
```php
function graphql_query(string $endpoint, string $query, array $variables = [], ?string $token = null): array
{
    $headers = ['Content-Type: application/json', 'User-Agent: Dunglas\'s minimal GraphQL client'];
    if (null !== $token) {
        $headers[] = "Authorization: bearer $token";
    }

    if (false === $data = @file_get_contents($endpoint, false, stream_context_create([
        'http' => [
            'method' => 'POST',
            'header' => $headers,
            'content' => json_encode(['query' => $query, 'variables' => $variables]),
        ]
    ]))) {
        $error = error_get_last();
        throw new \ErrorException($error['message'], $error['type']);
    }

    return json_decode($data, true);
}


function github_query(string $query, array $variables = []) {
	global $config;
	$ret = null;
	if ($config['gh_token']) { 
		$ret = graphql_query('https://api.github.com/graphql', $query, $variables, $config['gh_token']);
		sleep(5);	// Delay because Github does not like mutations too quick
	}
	return $ret;
}


function gh_create_discussion($title, $content) {
	global $config;

	$query = <<<'GRAPHQL'
		mutation MyMutation($repositoryId: ID!, $title: String!, $body: String!, $categoryId: ID!) { 
			createDiscussion(input: {
				repositoryId: $repositoryId, 
				title: $title, 
				body: $body, 
				categoryId: $categoryId
			}) 
		{ discussion {  id  } } }
		GRAPHQL;

	$vars = [
		'repositoryId' => $config['gh_repo'], 
		'title' => $title, 
		'body' => $content, 
		'categoryId' => $config['category_id']
	];

	$r = github_query($query, $vars);

	$discussion_id = $r['data']['createDiscussion']['discussion']['id'] ?? null;
	
	if ($discussion_id == null) { var_dump(">>> Discussion", $query, $vars, $r, $discussion_id); }

	return $discussion_id;
}


function gh_create_discussion_comment($discussionId, $content, $parent_comment = null) {
	global $config;

	$query = <<<'GRAPHQL'
				mutation MyMutation($discussionId: ID!, $body: String!, $replyToId: ID ) {
					addDiscussionComment(
					input: {
						discussionId: $discussionId, 
						body: $body, 
						replyToId: $replyToId
					}) 
					{ comment { id }}
				}
		GRAPHQL;

	$vars = [
		'discussionId' => $discussionId, 
		'body' => $content, 
		'replyToId' => $parent_comment
	];
	
	$r = github_query($query, $vars);

	$comment_id = $r['data']['addDiscussionComment']['comment']['id'] ?? null;

	//if (!$comment_id) { var_dump(">> Comment", $query, $vars, $r); }

	return $comment_id;
}

```
	
</details><br>


# Use the script

Follow these steps:
1. First download the  [wordpress-to-jekyll-exporter repository](https://github.com/rpeyron/wordpress-to-jekyll-exporter).
2. Set up the configuration variables in `jekyll-exporter.php`:
 	   - `$config['gh_token'] = "gho_xxxx";` : the token that you got with the `gh auth login` & `gh auth token` commands
 	   - `$config['gh_repo'] = "R_xxxxx";`   and  `$config['category_id'] = "DIC_xxxx";` : the identifiers of the repository and category you get in the [Giscus setup](https://giscus.app)
3. Activate migration to GitHub by uncommenting `// $config['comment_target_github'] = true;`
4. Customize the other fields you need
5. Run with `php jekyll-exporter-cli.php`

When there is comments on a post, it will:
- create a discussion related to the post with the URL of the post as discussion name, the excerpt of the post and the link to the post as body
- for each comment, a header mentioning the original author and date, and the content of the comment
- replies should be also put as reply comments

You can see an example of the result [on the discussion page of my GitHub repository](https://github.com/rpeyron/rpeyron.github.io/discussions) or a sample in the image below:

![]({{ 'files/2022/giscus_migration_result.png' | relative_url }})


That's it!
