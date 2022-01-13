from dotenv import dotenv_values

var = dotenv_values('vars.env')
print(var["YOUR_API_KEY"])