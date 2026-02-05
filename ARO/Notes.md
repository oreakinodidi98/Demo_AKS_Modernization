# ARO

## Set Up

[Guide](https://cloud.redhat.com/experts/quickstart-aro/)

- make sure to have [quota](https://portal.azure.com/#blade/Microsoft_Azure_Support/HelpAndSupportBlade/newsupportrequest)
- Requires Vnet and 2x Subment one for master and worker node
- Also remeber to Disable network policies for Private Link Service on the control plane subnet. So AREs can work on cluster
- Create cluster -> takes 30-45 min

To delete can use:

```bash
az aro delete -y \
  --resource-group $AZR_RESOURCE_GROUP \
  --name $AZR_CLUSTER
```

```bash
az group delete -y \
  --name $AZR_RESOURCE_GROUP
```

## Red Hat Developer Lightspeed

[Documentation](https://www.redhat.com/en/products/developer-lightspeed)

- **What**: Set of AI tools helping software development teams boost their productivity on openshit. Extension in VS code
- **Who**: For Developers
- **How**: Users get specialized, domain-specific answers within Red Hat **Developer Hub** and Red Hat’s **migration toolkit for applications**
  - **Migration toolkit for applications**: Focus on helping users modernize their applications faster with the help of AI-generated code tailored to your custom applications
    - Assists with source code refactoring within your integrated development environment (IDE).
    - Provides explanations and recommended code changes, and apply fixes with the click of a button
    - [Document](https://developers.redhat.com/products/mta/developer-lightspeed?extIdCarryOver=true&intcmp=7013a0000038AoiAAE&sc_cid=7013a000003SxHRAA0)
    - [MTA Demo](https://www.youtube.com/watch?v=DBQTiKAoGiA&t=9s)
    - MTA = Migrration Toolkit for Applications
    - Helps organizations safely Migrate and Modernize their application portfolio to leverage Openshift
      - VS Code extension
      - **Configuration**: Uses Yaml to define Model in VS code -> From Openshift, AzureOpenAI, Amazon Bedrock, Deepseek, GoogleGenAI
      - **Profiles and targets**: Configures Modernization Profiles and targets. E.G what we want to modernize from , Java -> Quarkus
      - **Application Analysis**: Can Add custom rules -> Run Analysis with a specific target profile, find potential issues
      - **Modernize with GenAI**: Goes through Analysis and producess solutions from the analysis so does Migrations/Modernization changes if neccessary.
      - **Agentic AI**: AI agents will gfix things that affect what has been resolved by GenAI in previous step. So fix related issues to the first solution
      - Solution Server: MCP server in openshift enviroment. Persistent memory of all the resolutions that have been done, allowing you to enforce patterns and practices for future use
  - **Developer Hub**: 
- **Benifits**:
  - **Workflow** integration: Reduce context-switching. Can access help without leaving your primary workspace.
  - **Context**: Uses Workspace context to answer questions
  - **Privacy**: Can bring your preferred large language model (LLM) and retain control over AI model performance, cost, and data privacy.
- **Why**: