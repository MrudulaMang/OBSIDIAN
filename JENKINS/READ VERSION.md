u said reding pacakge.json might be aproblem, explain

I did not mean `package.json` size is the problem.

I meant the architectural coupling can be the problem.

Reading this:

```
def version = readJSON(file: 'package.json').version
```

is not bad because of memory. The file is tiny.

The concern is this:

Jenkins now depends directly on your application’s internal file structure.

That creates coupling.

Example:

Today:

```
{  "version": "1.2.0"}
```

Tomorrow the team changes:

- monorepo structure
- version generated dynamically
- release version comes from Git tags
- build tool changes behavior

Now Jenkins breaks because it was tightly tied to one file assumption.

That is the problem—not RAM.

Compare:

Weak design:

```
readJSON('package.json').version
```

Jenkins knows app internals.

Stronger design:

```
npm pkg get version
```

Jenkins asks the build system.

Even stronger:

```
Git tag → CI derives version → artifact tagged
```

Jenkins depends on release process, not implementation details.

Same idea in Java:

Bad:

```
grep "<version>" pom.xml
```

Good:

```
mvn help:evaluate -Dexpression=project.version
```

Because Maven understands inheritance and effective version.

So the issue is not:  
“reading JSON wastes memory”

It is:  
“should CI be parsing app files directly?”

That is a systems design question, not a syntax question.