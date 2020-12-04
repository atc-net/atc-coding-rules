# Rule suppress suggestion

### Rule summary
| Key         | Value |
| ----------- |------------------------------------------------|
| Title       | SA1413UseTrailingCommasInMultiLineInitializers |
| CheckId     | SA1413 |
| Category    | Maintainability Rules |
| Link        | https://github.com/DotNetAnalyzers/StyleCopAnalyzers/blob/master/documentation/SA1413.md |

<br />
<br />

### What is the problem
Trailing comma or not?

I (Egil) wonder why we force a trailing comma after the last property when using object initializers, for example:

```csharp
new Pagination<ContractRecipe>
{
    PageSize = 50,
}
```

vs.

```csharp
new Pagination<ContractRecipe>
{
    PageSize = 50
}
```

or for larger initializsers:

```csharp
new QueryOptions
{
    PageSize = parameters.Request.PageSize,
    OnlyExactTagMatch = parameters.Request.OnlyExactTagMatch,
    OnlyMasterRecipes = parameters.Request.OnlyMasterRecipes,
    ContinuationToken = parameters.Request.ContinuationToken,
    Tags = parameters.Request.Tags.ToDomainType(),
}
```

vs.

```csharp
new QueryOptions
{
    PageSize = parameters.Request.PageSize,
    OnlyExactTagMatch = parameters.Request.OnlyExactTagMatch,
    OnlyMasterRecipes = parameters.Request.OnlyMasterRecipes,
    ContinuationToken = parameters.Request.ContinuationToken,
    Tags = parameters.Request.Tags.ToDomainType()
}
```

It seems unnatural to me. It seems inconsistent with e.g. how method and constructor calls work, where a trailing comma is not allowed.

Microsofts reasoning relates to being able to blame others in git history:
https://github.com/DotNetAnalyzers/StyleCopAnalyzers/blob/master/documentation/SA1413.md
