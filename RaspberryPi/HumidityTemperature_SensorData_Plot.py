# wp_plot-race-records.py
#
# Python3 script/workflow to plot the histogram of finish times.
#
# References:
# CSV import        :
# Grouped bar chart : https://plotly.com/python/bar-charts/
# Hover text        : https://plotly.com/python/hover-text-and-formatting/
# HTML embedding    : https://plotly.com/python/interactive-html-export/
# Toolbar           : https://plotly.com/python/configuration-options/
# Legend            : https://plotly.com/python/legend/
# Multiple y-axes   : https://stackoverflow.com/questions/60950480/plot-bar-charts-with-multiple-y-axes-in-plotly-in-the-normal-barmode-group-way
# PDF                 : https://plotly.com/python/static-image-export/

# Necessary libraries
from functions import *

# Argument check
if len(sys.argv) < 2:
  print("")
  print("  Usage:")
  print("  python3 " + sys.argv[0] + " Season")
  print("  python3 " + sys.argv[0] + " Overall")
  print("  python3 " + sys.argv[0] + " 20XXEventHandle")
  print("")
  sys.exit()

## Race Records (All)

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_All'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'
file_pdf  = str(folder) + str(event_tag) + str(file_name) + '.pdf'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the event type and assign color
g_colors_races = []

# for i in range(len(df)):
#   if str(df['Distance'][i]) == "3.11":
#     g_colors_races.append(g_color_race_5k)
#   else:
#     if str(df['Distance'][i]) == "6.22":
#       g_colors_races.append(g_color_race_10k)
#     else:
#       if str(df['Distance'][i]) == "13.11":
#         g_colors_races.append(g_color_race_half_marathon)
#       else:
#         if str(df['Distance'][i]) == "26.22":
#           g_colors_races.append(g_color_race_marathon)
#         else:
#           g_colors_races.append(g_color_race_generic)

for i in range(len(df)):
  if (float(str(df['Distance'][i])) > 0.00 and float(str(df['Distance'][i])) <= 6.22):
    g_colors_races.append(g_color_race_00k_10k)
  else:
    if (float(str(df['Distance'][i])) > 6.22 and float(str(df['Distance'][i])) <= 12.44):
      g_colors_races.append(g_color_race_10k_20k)
    else:
      if (float(str(df['Distance'][i])) > 12.44 and float(str(df['Distance'][i])) <= 18.66):
        g_colors_races.append(g_color_race_20k_30k)
      else:
        if (float(str(df['Distance'][i])) > 18.66 and float(str(df['Distance'][i])) <= 24.88):
          g_colors_races.append(g_color_race_30k_40k)
        else:
          if (float(str(df['Distance'][i])) > 24.88 and float(str(df['Distance'][i])) <= 31.10):
            g_colors_races.append(g_color_race_40k_50k)
          else:
            if (float(str(df['Distance'][i])) > 31.10 and float(str(df['Distance'][i])) <= 37.32):
              g_colors_races.append(g_color_race_50k_60k)
            else:
              g_colors_races.append(g_color_race_generic)

# print(g_colors_races)

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_races,
                      opacity      = 0.75,
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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        # range          = [range_min, range_max]   
                                      ),
                   hovermode        = 'x unified',
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

# Show the graph (opens a browser)
# fig.show()

# Write to HTML and PDF
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)
fig.write_image(file_pdf)


## Race Records (Run)

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_Run'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'
file_pdf  = str(folder) + str(event_tag) + str(file_name) + '.pdf'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the event type and assign color
g_colors_races = []

for i in range(len(df)):
  if (float(str(df['Distance'][i])) > 0.00 and float(str(df['Distance'][i])) <= 6.22):
    g_colors_races.append(g_color_race_00k_10k)
  else:
    if (float(str(df['Distance'][i])) > 6.22 and float(str(df['Distance'][i])) <= 12.44):
      g_colors_races.append(g_color_race_10k_20k)
    else:
      if (float(str(df['Distance'][i])) > 12.44 and float(str(df['Distance'][i])) <= 18.66):
        g_colors_races.append(g_color_race_20k_30k)
      else:
        if (float(str(df['Distance'][i])) > 18.66 and float(str(df['Distance'][i])) <= 24.88):
          g_colors_races.append(g_color_race_30k_40k)
        else:
          if (float(str(df['Distance'][i])) > 24.88 and float(str(df['Distance'][i])) <= 31.10):
            g_colors_races.append(g_color_race_40k_50k)
          else:
            if (float(str(df['Distance'][i])) > 31.10 and float(str(df['Distance'][i])) <= 37.32):
              g_colors_races.append(g_color_race_50k_60k)
            else:
              g_colors_races.append(g_color_race_generic)

# print(g_colors_races)

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_races,
                      opacity      = 0.75,
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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        # range          = [range_min, range_max]   
                                      ),
                   hovermode        = 'x unified',
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

# Show the graph (opens a browser)
# fig.show()

# Write to HTML and PDF
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)
fig.write_image(file_pdf)


## Race Records (Ski)

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_Ski'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'
file_pdf  = str(folder) + str(event_tag) + str(file_name) + '.pdf'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the event type and assign color
g_colors_races = []

for i in range(len(df)):
  if (float(str(df['Distance'][i])) > 0.00 and float(str(df['Distance'][i])) <= 6.22):
    g_colors_races.append(g_color_race_00k_10k)
  else:
    if (float(str(df['Distance'][i])) > 6.22 and float(str(df['Distance'][i])) <= 12.44):
      g_colors_races.append(g_color_race_10k_20k)
    else:
      if (float(str(df['Distance'][i])) > 12.44 and float(str(df['Distance'][i])) <= 18.66):
        g_colors_races.append(g_color_race_20k_30k)
      else:
        if (float(str(df['Distance'][i])) > 18.66 and float(str(df['Distance'][i])) <= 24.88):
          g_colors_races.append(g_color_race_30k_40k)
        else:
          if (float(str(df['Distance'][i])) > 24.88 and float(str(df['Distance'][i])) <= 31.10):
            g_colors_races.append(g_color_race_40k_50k)
          else:
            if (float(str(df['Distance'][i])) > 31.10 and float(str(df['Distance'][i])) <= 37.32):
              g_colors_races.append(g_color_race_50k_60k)
            else:
              g_colors_races.append(g_color_race_generic)

# print(g_colors_races)

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_races,
                      opacity      = 0.75,
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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        # range          = [range_min, range_max]   
                                      ),
                   hovermode        = 'x unified',
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

# Show the graph (opens a browser)
# fig.show()

# Write to HTML and PDF
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)
fig.write_image(file_pdf)


## Marathon

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_Marathon'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'
file_pdf  = str(folder) + str(event_tag) + str(file_name) + '.pdf'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the finish times and assign PR color
df['FinishTime']  = pd.to_datetime(df.FinishTime)
df['BQ']          = pd.to_datetime(df.BQ)
Time_Format       = '%Y-%m-%d %H:%M:%S'
FinishTime_Best   = "2020-01-01 04:06:21"
g_colors_marathon = []

# Color code successful, new PR, DNF and BQ attempts
for i in range(len(df)):
  Timestamp_Best  = datetime.datetime.strptime(FinishTime_Best, Time_Format)
  Timestamp_New   = df['FinishTime'][i]
  Timestamp_BQ    = df['BQ'][i]
  EventStatus     = df['Finished'][i].strip()
  EventStatus_DNF = "DNF"
  if EventStatus == EventStatus_DNF:
    g_colors_marathon.append(g_color_dnf)
  else:
    if Timestamp_New <= Timestamp_Best:
      FinishTime_Best = str(df['FinishTime'][i])
      g_colors_marathon.append(g_color_pr_yes)
      if Timestamp_New <= Timestamp_BQ:
        g_colors_marathon[i] = g_color_bq_pr
    else:
      FinishTime_Best = str(Timestamp_Best)
      g_colors_marathon.append(g_color_pr_no)
      if Timestamp_New <= Timestamp_BQ:
        g_colors_marathon[i] = g_color_bq

# print(g_colors_marathon)
# print(g_colors_marathon[8])

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
# https://stackoverflow.com/questions/69442203/how-to-hide-legend-selectively-in-a-plotly-line-plot
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_marathon,
                      opacity      = 0.75,
                      showlegend   = False,
                    )
             )

fig.add_trace(go.Scatter(
                      x          = df['RaceName'],
                      y          = df['AverageTime'],
                      name       = 'Average Time',
                      opacity    = 0.75,
                      mode       = 'lines',
                      line_shape = 'spline',
                      line       = dict(
                                     color = g_color_metric_average,
                                     width = g_line_width_goal,
                                   ),                      
                    )
             )

# fig.add_trace(go.Scatter(
#                       x          = df['RaceName'],
#                       y          = df['WorldRecord'],
#                       name       = 'World Record',
#                       opacity    = 0.75,
#                       mode       = 'lines',
#                       line_shape = 'spline',
#                       line       = dict(
#                                      color = g_color_world_record,
#                                      width = g_line_width_goal,
#                                    ),
#                     )
#              )
 
fig.add_trace(go.Scatter(
                      x          = df['RaceName'],
                      y          = df['BQ'],
                      name       = 'BQ',
                      opacity    = 0.75,
                      mode       = 'lines',
                      line_shape = 'spline',
                      line       = dict(
                                     color = g_color_bq_reqd,
                                     width = g_line_width_goal,
                                   ),
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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        range          = ['2020-01-01 00:00:00', '2020-01-01 04:30:00']   
                                      ),
                   hovermode        = 'x unified',
                   plot_bgcolor     = g_plot_bgcolor,
                   legend           = dict(
                                        orientation    = 'h',
                                        xanchor        = 'right',
                                        yanchor        = 'top',
                                        x              = 1.00,
                                        y              = 0.99,
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
                  gridcolor  = g_yaxes_gridcolor,
                )

# Show the graph (opens a browser)
# fig.show()

# Write to HTML
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)


## Half Marathon

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_HalfMarathon'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the finish times and assign PR color
df['FinishTime']      = pd.to_datetime(df.FinishTime)
Time_Format           = '%Y-%m-%d %H:%M:%S'
FinishTime_Best       = "2020-01-01 05:00:00"
g_colors_halfmarathon = []

for i in range(len(df)):
  Timestamp_Best   = datetime.datetime.strptime(FinishTime_Best, Time_Format)
  Timestamp_New    = df['FinishTime'][i]
  TimeDiff         = Timestamp_New - Timestamp_Best
  TimeDiff_seconds = TimeDiff.seconds
  if Timestamp_New <= Timestamp_Best:
    FinishTime_Best = str(df['FinishTime'][i])
    g_colors_halfmarathon.append(g_color_pr_yes)
  else:
    FinishTime_Best = str(Timestamp_Best)
    g_colors_halfmarathon.append(g_color_pr_no)

# print(g_colors_halfmarathon)

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_halfmarathon,
                      opacity      = 0.75,
                      showlegend   = False,
                    )
             )

fig.add_trace(go.Scatter(
                      x          = df['RaceName'],
                      y          = df['AverageTime'],
                      name       = 'Average Time',
                      opacity    = 0.75,
                      mode       = 'lines',
                      line_shape = 'spline',
                      line       = dict(
                                     color = g_color_metric_average,
                                     width = g_line_width_goal,
                                   ),
                    )
             )

# fig.add_trace(go.Scatter(
#                       x          = df['RaceName'],
#                       y          = df['WorldRecord'],
#                       name       = 'World Record',
#                       opacity    = 0.75,
#                       mode       = 'lines',
#                       line_shape = 'spline',
#                       line       = dict(
#                                      color = g_color_world_record,
#                                      width = g_line_width_goal,
#                                    ),
#                     )
#              )

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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        range          = ['2020-01-01 00:00:00', '2020-01-01 03:00:00']
                                      ),
                   hovermode        = 'x unified',
                   plot_bgcolor     = g_plot_bgcolor,
                   legend           = dict(
                                        orientation    = 'h',
                                        xanchor        = 'right',
                                        yanchor        = 'top',
                                        x              = 1.00,
                                        y              = 0.95,
                                      ),
                   margin           = dict(
                                        l = 0,
                                        r = 0,
                                      ),
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
                  gridcolor  = g_yaxes_gridcolor,
                )

# Show the graph (opens a browser)
# fig.show()

# Write to HTML
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)


## 10k

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_TenK'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the finish times and assign PR color
df['FinishTime'] = pd.to_datetime(df.FinishTime)
Time_Format      = '%Y-%m-%d %H:%M:%S'
FinishTime_Best  = "2020-01-01 05:00:00"
g_colors_tenk    = []

for i in range(len(df)):
  Timestamp_Best   = datetime.datetime.strptime(FinishTime_Best, Time_Format)
  Timestamp_New    = df['FinishTime'][i]
  TimeDiff         = Timestamp_New - Timestamp_Best
  TimeDiff_seconds = TimeDiff.seconds
  if Timestamp_New <= Timestamp_Best:
    FinishTime_Best = str(df['FinishTime'][i])
    g_colors_tenk.append(g_color_pr_yes)
  else:
    FinishTime_Best = str(Timestamp_Best)
    g_colors_tenk.append(g_color_pr_no)

# print(g_colors_tenk)

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_tenk,
                      opacity      = 0.75,
                      showlegend   = False,
                    )
             )

fig.add_trace(go.Scatter(
                      x          = df['RaceName'],
                      y          = df['AverageTime'],
                      name       = 'Average Time',
                      opacity    = 0.75,
                      mode       = 'lines',
                      line_shape = 'spline',
                      line       = dict(
                                     color = g_color_metric_average,
                                     width = g_line_width_goal,
                                   ),
                    )
             )

# fig.add_trace(go.Scatter(
#                       x          = df['RaceName'],
#                       y          = df['WorldRecord'],
#                       name       = 'World Record',
#                       opacity    = 0.75,
#                       mode       = 'lines',
#                       line_shape = 'spline',
#                       line       = dict(
#                                      color = g_color_world_record,
#                                      width = g_line_width_goal,
#                                    ),
#                     )
#              )

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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        range          = ['2020-01-01 00:00:00', '2020-01-01 01:20:00']
                                      ),
                   hovermode        = 'x unified',
                   plot_bgcolor     = g_plot_bgcolor,
                   legend           = dict(
                                        orientation    = 'h',
                                        xanchor        = 'right',
                                        yanchor        = 'top',
                                        x              = 1.00,
                                        y              = 0.99,
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
                  gridcolor  = g_yaxes_gridcolor,
                )

# Show the graph (opens a browser)
# fig.show()

# Write to HTML
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)


## 5k

# Variables
event_tag = sys.argv[1]
folder    = g_folder
file_name = '/RaceRecords_FiveK'
file_csv  = str(folder) + str(event_tag) + str(file_name) + '.csv'
file_html = str(folder) + str(event_tag) + str(file_name) + '.html'

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Compare the finish times and assign PR color
df['FinishTime'] = pd.to_datetime(df.FinishTime)
Time_Format      = '%Y-%m-%d %H:%M:%S'
FinishTime_Best  = "2020-01-01 00:55:00"
g_colors_fivek   = []

for i in range(len(df)):
  Timestamp_Best   = datetime.datetime.strptime(FinishTime_Best, Time_Format)
  Timestamp_New    = df['FinishTime'][i]
  TimeDiff         = Timestamp_New - Timestamp_Best
  TimeDiff_seconds = TimeDiff.seconds
  if Timestamp_New <= Timestamp_Best:
    FinishTime_Best = str(df['FinishTime'][i])
    g_colors_fivek.append(g_color_pr_yes)
  else:
    FinishTime_Best = str(Timestamp_Best)
    g_colors_fivek.append(g_color_pr_no)

# print(g_colors_fivek)

# Read the CSV
df = pd.read_csv(file_csv)

# DEBUG
# df.head()

# Overall appearance
config = g_config

# Create blank figure
fig = go.Figure()

# Finish Time
fig.add_trace(go.Bar(
                      x            = df['RaceName'],
                      y            = df['FinishTime'],
                      name         = 'Finish Time',
                      marker_color = g_colors_fivek,
                      opacity      = 0.75,
                      showlegend   = False,
                    )
             )

fig.add_trace(go.Scatter(
                      x          = df['RaceName'],
                      y          = df['AverageTime'],
                      name       = 'Average Time',
                      opacity    = 0.75,
                      mode       = 'lines',
                      line_shape = 'spline',
                      line       = dict(
                                     color = g_color_metric_average,
                                     width = g_line_width_goal,
                                   ),
                    )
             )

# fig.add_trace(go.Scatter(
#                       x          = df['RaceName'],
#                       y          = df['WorldRecord'],
#                       name       = 'World Record',
#                       opacity    = 0.75,
#                       mode       = 'lines',
#                       line_shape = 'spline',
#                       line       = dict(
#                                      color = g_color_world_record,
#                                      width = g_line_width_goal,
#                                    ),
#                     )
#              )

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
                                        # title          = 'Race Name',
                                        titlefont_size = g_xaxis_titlefont_size,
                                        tickfont_size  = g_xaxis_tickfont_size
                                      ),
                   # https://github.com/plotly/plotly.py/issues/2393
                   yaxis            = dict(
                                        title          = 'Finish Time (h:mm:ss)',
                                        titlefont_size = g_yaxis_titlefont_size,
                                        tickfont_size  = g_yaxis_tickfont_size,
                                        tickformat     = '%H:%M:%S',
                                        range          = ['2020-01-01 00:00:00', '2020-01-01 00:35:00']
                                      ),
                   hovermode        = 'x unified',
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
                  gridcolor  = g_yaxes_gridcolor,
                )

# Show the graph (opens a browser)
# fig.show()

# Write to HTML and PDF
fig.write_html(file_html, full_html=True, include_plotlyjs = 'cdn', config = config)
fig.write_image(file_pdf)
