# ATC-NET Coding Rules and Guidelines

## What is it?
This github reposotory contains coding rules which are defined by the ATC core team, for use in various code projects. If you are about to create a new project, it will be a good start to download files from the [distribution](/tree/main/distribution) for you editor.

The main focus for the ATC core team is about Visual Studio og Visual Studio Code and .NET/C#. [.NET Code Style](#)

<br/>

## Why?
Let your team use the same set of code rules for your project - which is a collection of code analyzers with all rules treated errors as default.

When a rule is found annoying and you want to deactivate it - this can only be done through a process where there must be argumentation with why, after which a treatment process is started by the ATC core team and ends with a decision on the best solution which is documented and executed.

**So no rules must be deactivated by a single person and must first be documented so that one can refer to the decision basis for handling the rule. !**

<br/>

## How to use it?
All you have to do is drop it into the root of your project. Then any time you open a file in Visual Studio, the .editorconfig file settings will be used to help format the document and also raise warnings if your code style and formatting does not conform. For Visual Studio Code, you can install the [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) extension to get support.

<br/>
<br/>
<br/>

## Q & A:
### Q: I see a rule is suppressed - why?
1) If the rule is suppressed in code by a `SuppressMessage` attrubute, hopefully the `Justification` description should clarify it.
2) If the rule is suppressed in the `.editorconfig` and it is not defined under you own _custom section_ then the rule must be found under [documentation](/documentation/CodeAnalyzersRules/rules-overview.md)
3) I can't see the rule defined as described in bullet 1 or 2 - Then the rule is **INVALID**  - use the git-blame and get the code fixed with the person/team or/and flollow up on the process for code quality - improve the PullRequest-Review process.

### Q: I have a suggestion to a rule I dont like
If you have a rule you don't like, please feel free to startup a suggestion proceess:

Create a [issue](/issues) base on the [rule-suppress-suggestion-template](/documentation/CodeAnalyzersRules/TEMPLATE-rule-suppress-suggestion.md)
[Read more](/documentation/CodeAnalyzersRules/rule-suppress-process.md)

<br/>
<br/>
<br/>

### .NET Code Style
Extensive code style settings for C# have been defined that require the latest C# features to be used.

All .NET naming conventions are consistent with the .NET Framework Design Guideline's [Naming Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/naming-guidelines).

### What is .editorconfig?
EditorConfig helps developers define and maintain consistent coding styles between different editors and IDEs. The EditorConfig project consists of a file format for defining coding styles and a collection of text editor plugins that enable editors to read the file format and adhere to defined styles. EditorConfig files are easily readable and they work nicely with version control systems. Find out more at [editorconfig.org](http://editorconfig.org/) and the [Visual Studio Docs](https://docs.microsoft.com/en-us/visualstudio/ide/editorconfig-code-style-settings-reference).
