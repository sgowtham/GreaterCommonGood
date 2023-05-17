# HumidityTemperature_SensorData_Plot.py
#
# Python3 script/workflow to plot the histogram of finish times.
#
# Usage:
# python3 HumidityTemperature_SensorData_Plot.py

# Necessary libraries
from functions import *

# Argument check
if len(sys.argv) != 2:
  print("")
  print("  Usage: python3 " + sys.argv[0] + " LOCATION_TIMESTAMP")
  print("   e.g.: python3 " + sys.argv[0] + " HoughtonMI_202305150543")
  print("")
  sys.exit()

# Variables
location_timestamp = sys.argv[1]
file_name          = 'HumidityTemperature_SensorData'
file_csv           = str(location_timestamp) + '_' + str(file_name) + '.csv'
file_html          = str(location_timestamp) + '_' + str(file_name) + '.html'
file_pdf           = str(location_timestamp) + '_' + str(file_name) + '.pdf'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

for metric in df.columns[1:]:
  metric_lc          = 'g_color_' + metric.lower()
  metric_color_value = globals()[metric_lc]

  fig.add_trace(go.Scatter(
                        x          = df['Timestamp'],
                        y          = df[metric],
                        name       = metric,
                        opacity    = 0.95,
                        mode       = 'lines+markers',
                        line_shape = 'spline',
                        marker     = dict(
                                       color = metric_color_value,
                                       size  = g_marker_size_single,
                                     ),
                        line       = dict(
                                       color = metric_color_value,
                                       width = g_line_width_goal_single,
                                     )
                      )
               )

# Update layout
fig.update_layout(
                   title_text       = '',
                   title_x          = g_title_x,
                   title_font_color = g_title_font_color,
                   title_font_size  = g_title_font_size,
                   barmode          = 'group', 
                   bargap           = 0.35, 
                   bargroupgap      = 0.25, 
                   xaxis_tickangle  = g_xaxis_tickangle,
                   xaxis            = dict(
                                        title          = 'Time (h:mm:ss)',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                      ),
                   hovermode        = g_hovermode,
                   plot_bgcolor     = g_plot_bgcolor,
                   legend           = dict(
                                        orientation    = 'h',
                                        xanchor        = 'right',
                                        yanchor        = 'top',
                                        x              = 1.00,
                                        y              = 0.95,
                                      )
                 )

fig.update_xaxes(
                  showline  = True,
                  linewidth = g_xaxes_linewidth,
                  linecolor = g_xaxes_linecolor
                )

fig.update_yaxes(
                  showline   = True,
                  linewidth  = g_yaxes_linewidth,
                  linecolor  = g_yaxes_linecolor,
                  gridwidth  = g_yaxes_gridwidth,
                  gridcolor  = g_yaxes_gridcolor
                )

# Show the graph (opens a browser when run locally)
# fig.show()

# Write to HTML and PDF
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)
fig.write_image(file_pdf)
