var builder = DistributedApplication.CreateBuilder(args);

var blazorchatdeepseekr1 = builder.AddProject<Projects.BlazorChatDeepSeekR1>("blazorchatdeepseekr1")
    .WithExternalHttpEndpoints();

builder.Build().Run();