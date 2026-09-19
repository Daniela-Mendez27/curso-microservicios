using AddMember.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton(_ => new ServiceBus("localhost", "pickage"));

var app = builder.Build();

app.MapPost("/addmember", async (
    string name,
    string lastname,
    string birthyear,
    ServiceBus serviceBus) =>
{
    await serviceBus.SendMessageAsync(name, lastname, birthyear);

    return Results.Ok($"Miembro {name} agregado con éxito a RabbitMQ.");
});

app.Run();
