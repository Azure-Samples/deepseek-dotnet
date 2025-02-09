var builder = DistributedApplication.CreateBuilder(args);

var blazorchatdeepseekr1 = builder.AddProject<Projects.BlazorChatDeepSeekR1>("blazorchatdeepseekr1")
    .WithExternalHttpEndpoints();

builder.Build().Run();


//// Running in publish mode
//if (builder.ExecutionContext.IsPublishMode)
//{
//    var cnnstring_deepseekr1 = builder.AddConnectionString("deepseekr1ai");

//    var deploymentName = builder.AddParameter(
//        name: "deploymentname",
//        value: "DeepSeek-R1",
//        secret: true);
//    var endpoint = builder.AddParameter(
//        name: "endpoint",
//        value: "http://",
//        secret: true);
//    var tenantId = builder.AddParameter(
//        name: "tenantid",
//        value: "tbd",
//        secret: true);

//    blazorchatdeepseekr1
//        .WithReference(cnnstring_deepseekr1)
//        .WithEnvironment("deploymentname", deploymentName)
//        .WithEnvironment("endpoint", endpoint)
//        .WithEnvironment("tenantid", tenantId);
//}


