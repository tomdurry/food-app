import { App } from "cdktf";
import { AccountStack } from "../lib/account-stack-local";
import { PipelineStack } from "../lib/pipeline-stack-local";
import { RecipeGenerationStack } from "../lib/recipe-generation-stack";

const app = new App();
new AccountStack(app, "account-stack-local");
new PipelineStack(app, "pipeline-stack-local");
new RecipeGenerationStack(app, "recipe-generation-stack");
app.synth();
