import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from pandas import DataFrame
import requests
from dash.dependencies import Input, Output


url = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' + \
                    '$select= spc_common, count(tree_id)&$group= spc_common')

def get_df(url):
    resp = requests.get(url, verify=False)
    json = resp.text
    return pd.read_json(json)


def get_plant_options():
    ser = get_df(url)['spc_common'].dropna()
    options = []
    for plant in ser[1:]:
        options.append({'label': plant.title(), 'value': plant.title()})
    return options



boroughs_options = [
    {'label': 'Bronx', 'value': 'Bronx'},
    {'label': 'Queens', 'value': 'Queens'},
    {'label': 'Brooklyn', 'value': 'Brooklyn'},
    {'label': 'Manhattan', 'value': 'Manhattan'},
    {'label': 'Staten Island', 'value': 'Staten Island'},
]

plant_options = get_plant_options()

colors = {
    'background': '#111111',
    'text': '#7FDBFF'
}
span_style = {
    'display': 'inline',
    'width': '20%',
    'height': '100px',
    'padding': '5px',
    'background-color': colors['background'],
    'color': 'gray'
}

style = {'background-color': colors['background'], 'color': 'gray'}


def dropdown(label_name, options, id):
    return html.Span(style=span_style,
                     children=[
                         html.Label(label_name, style=style),
                         dcc.Dropdown(
                             style=style,
                             options=options,
                             value=options[0]['value'],
                             multi=False,
                             id=id
                         )
                     ])


def makebar(current_borough = boroughs_options[0]['value'] , current_plant = plant_options[0]['value'] ):
    url = ('https://data.cityofnewyork.us/resource/nwxe-4ae8.json?' + \
           '$select=health,count(*) *100/ sum(count(*)) over() as proportion' + \
           '&$where=boroname=\'' + current_borough + '\' and spc_common=\'' + current_plant.lower() + '\'' + \
           '&$group=health')
    df = get_df(url)
    if (df.empty):
        return []
    else:
        health = df.health.unique()
        return [{'x': health, 'y': df['proportion'], 'marker': {'color': df['proportion'], 'colorscale': 'Viridis'},
                 'type': 'bar'}]



app = dash.Dash()

app.layout = html.Div(style={'backgroundColor': colors['background'], 'width': '35%'}, children=[
    html.H1(
        children='HW4',
        style={
            'textAlign': 'center',
            'color': colors['text'],
        }
    ),
    html.Div(children='', style={
        'textAlign': 'center',
        'color': colors['text']
    }, id='headline'),

    html.Div(style={'backgroundColor': colors['background'], 'width': '30%'}, children=[

        dropdown('Select Borough', boroughs_options, 'borough_dropdown'),
        dropdown('Select Plant', plant_options, 'plant_dropdown'),

    ]
             ),

    dcc.Graph(
        id='Graph1',
        figure={}
    ),

])


@app.callback(
    Output(component_id='Graph1', component_property='figure'),
    [Input(component_id='borough_dropdown', component_property='value'),
     Input(component_id='plant_dropdown', component_property='value')]
)
def update_output_div(boro, plant):
    figure_value = {
        'data': makebar(boro,plant),
        'layout': {
            'plot_bgcolor': colors['background'],
            'paper_bgcolor': colors['background'],
            'font': {
                'color': colors['text']
            }
        }
    }
    return figure_value


@app.callback(
    Output(component_id='headline', component_property='children'),
    [Input(component_id='borough_dropdown', component_property='value'),
     Input(component_id='plant_dropdown', component_property='value')]
)
def update_output_headline(boro, plant):
    return 'Borough: ' + boro + ',  Plant: ' + plant


if __name__ == '__main__':
    app.run_server(debug=True)