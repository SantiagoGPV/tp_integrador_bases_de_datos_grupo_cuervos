# tp_integrador_bases_de_datos_grupo_cuervos
Trabajo Practico integrador a entregar para la materia de Bases de Datos 2026

Grupo Cuervos

Integrantes

Benay, Franco

Danielis, Mateo

Oliva, Emmanuel

Poerio, Santiago

Prediger, Misael

# Instrucciones de Instalacion
Para nuestro entorno de trabajo nosotros utilizamos VsCode

Utilizamos las siguientes extensiones para llevar a cabo el trabajo:

Jupyter: https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter

Python: https://marketplace.visualstudio.com/items?itemName=ms-python.python

(Últimas versiones)

También Utilizamos las siguientes librerías:

mysql-connector-python 

python-dotenv 

pandas

google-genai

Descargar ejecutando el siguiente comando en la terminal:

pip install mysql-connector-python python-dotenv pandas google-genai

# Obtener clave API

Dirigirse a Google AI Studio y hacer el log-in con tu cuenta de google

https://aistudio.google.com/prompts/new_chat

Una vez iniciado sesion se debera de tocar el boton de "obtener llave de API" o "Get API Key"

Cuando entren a la seccion de creacion de llaves de API vuelvan a interactuar con el boton de "obtener llave de API" o "Get API Key"

Si no tienen un proyecto creado crear un proyecto y luego terminar los pasos de creacion

Luego de eso la pagina les dara su clave de API

# Preparacion de archivo .env

Descargar el archivo .env.example y remover la terminacion .example del archivo

Dentro del archivo se encuentra la siguiente estructura:

LLM_API_KEY=

DB_HOST=localhost

DB_USER=

DB_PASSWORD=

DB_NAME=tpIntegradorCuervos

La estructura debera ser completada con, la llave de google gemini, el usuario de la base de datos local, la contraseña de la base de dato local.
Aqui un ejemplo de como deberia verse:

LLM_API_KEY=AQ.Ab8RN6L5rasd82jlfo4Q8RB1_0S9YzuJlkJLrtwUeufwQi0AuwQ

DB_HOST=localhost

DB_USER=root

DB_PASSWORD=ContraseñaTp123

DB_NAME=tpIntegradorCuervos
