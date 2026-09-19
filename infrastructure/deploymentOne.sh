#!/bin/bash

cd ..

mkdir -p microservicios
cd microservicios

dotnet new webapi -n GetAdults -o GetAdults --force
dotnet new webapi -n GetChildren -o GetChildren --force
dotnet new webapi -n GetAdultById -o GetAdultById --force
dotnet new webapi -n GetChildById -o GetChildById --force
dotnet new webapi -n AddMember -o AddMember --force
dotnet new webapi -n PickAge -o PickAge --force
dotnet new webapi -n AddChild -o AddChild --force
dotnet new webapi -n AddAdult -o AddAdult --force