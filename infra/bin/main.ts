import { App } from "cdktf";
import { AccountStack } from "../lib/account-stack";
import { PipelineStack } from "../lib/pipeline-stack";
import { RecipeGenerationStack } from "../lib/recipe-generation-stack";

const app = new App();
new AccountStack(app, "account-stack");
new PipelineStack(app, "pipeline-stack");
new RecipeGenerationStack(app, "recipe-generation-stack");
app.synth();
