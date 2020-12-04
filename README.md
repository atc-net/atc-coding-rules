# ATC-NET Coding Rules and Guidelines

[ATC Analyzers Rules decisions overview](/documentation/CodeAnalyzersRules/rules-overview.md)

## What is it?
This github repository contains coding rules which are defined by the ATC core team for use in various code projects. If you are about to create a new project, it will be a good start to download files from the [distribution](/tree/main/distribution) as a starting point for your solution.

The main focus for the ATC core team is Visual Studio, Visual Studio Code and .NET/C#. [.NET Code Style](#)

## Incentative
Let your team use the same set of code rules for your project - which is a collection of code analyzers with all rules treated as errors by default.

Extensive code style settings for C# have been defined that require the latest C# features to be used.

All .NET naming conventions are consistent with the .NET Framework Design Guideline's [Naming Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/naming-guidelines).

## Process around changes
When a rule is found annoying and someone wants to deactivate it, this must follow a standard procedure. Firstly argumentation must be in place as to why the rule should be disabled. Once this argumentation is in place, a session with the ATC core team can be held, where a decision will be made and afterwards executed and documented.

**This means that NO rules must be deactivated by a single person and must first be documented so that everyone later can refer to this!**

## Usage
Take a copy of the [distribution](/tree/main/distribution) folder and drop it into the root of your project. Once this is done, when opening a file in Visual Studio, the .editorconfig file settings will be used to help format the document and also raise warnings if your code style and formatting does not conform.

For Visual Studio Code, you can install the [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) extension.

## Q & A:
### Q: I see a rule is suppressed - why?
1) If the rule is suppressed in code by a `SuppressMessage` attrubute, hopefully the `Justification` description should clarify it.
2) If the rule is suppressed in the `.editorconfig` and it is not defined under you own _custom section_ then the rule must be found under [documentation](/documentation/CodeAnalyzersRules/rules-overview.md)
3) I can't see the rule defined as described in bullet 1 or 2 - Then the rule is **INVALID**  - use `git blame` and get the code fixed with the person/team or/and follow up on the process for code quality - e.g. improve the PullRequest-Review process.

### Q: I have a suggestion to a rule I dont like
If you have a rule you don't like, please feel free to start a suggestion proceess.

Create a [issue](https://github.com/atc-net/atc-coding-rules/issues/new/choose) base on the `Rule suppress suggestion`

Read more on this in the [rule suppression process](/documentation/CodeAnalyzersRules/rule-suppress-process.md).

### Q: What is a .editorconfig file?
EditorConfig helps developers define and maintain consistent coding styles between different editors and IDEs. The EditorConfig project consists of a file format for defining coding styles and a collection of text editor plugins that enable editors to read the file format and adhere to defined styles. EditorConfig files are easily readable and they work nicely with version control systems. Find out more at:
* [editorconfig.org](http://editorconfig.org/)
* [Visual Studio Docs - editor](https://docs.microsoft.com/en-us/visualstudio/ide/create-portable-custom-editor-options?view=vs-2019)
* [Visual Studio Docs - code style](https://docs.microsoft.com/en-us/visualstudio/ide/editorconfig-code-style-settings-reference).
