import os
import pandas as pd
import plotly.graph_objects as go
import plotly.subplots as sp
import plotly.express as px

# Load data from CSV
df = pd.read_csv('benchmark_results.csv')

# Creating trace for the runtime of each run (3D Plot)
trace1_3d = go.Scatter3d(
    x=df['Run Number'],
    y=df['Iterations'],
    z=df['Runtime (seconds)'],
    mode='markers',
    marker=dict(
        size=12,
        color=df['Runtime (seconds)'],
        colorscale='Viridis',
        opacity=0.8,
        colorbar=dict(title='Runtime (s)')
    ),
    name='Runtime per Run',
    hovertemplate="Run: %{x}<br>Iterations: %{y}<br>Runtime: %{z}s<extra></extra>"
)

# Creating trace for the cumulative average runtime (3D Plot)
trace2_3d = go.Scatter3d(
    x=df['Run Number'],
    y=df['Iterations'],
    z=df['Cumulative Average Runtime (seconds)'],
    mode='lines',
    line=dict(color='red', width=2),
    name='Cumulative Average Runtime',
    hovertemplate="Run: %{x}<br>Iterations: %{y}<br>Avg Runtime: %{z}s<extra></extra>"
)

# Extract only the last run of each iteration set for 2D Plot
last_runs = df.groupby('Iterations (Scientific Notation)').last().reset_index()

# Create 2D plot
fig_2d = px.scatter(
    last_runs,
    x='Iterations (Scientific Notation)',
    y='Cumulative Average Runtime (seconds)',
    labels={'Iterations (Scientific Notation)': 'Iterations',
            'Cumulative Average Runtime (seconds)': 'Average Runtime (seconds)'},
    title='Average Runtime vs Iterations',
    hover_data={'Iterations (Scientific Notation)': ':.0e',
                'Cumulative Average Runtime (seconds)': ':.2f'}
)

# Create a subplot layout (1 row, 2 columns)
fig = sp.make_subplots(
    rows=1, cols=2,
    specs=[[{'type': 'scatter3d'}, {'type': 'scatter'}]],
    subplot_titles=('3D Plot of Benchmark Results', 'Average Runtime vs Iterations')
)

# Add 3D traces to the first column
fig.add_trace(trace1_3d, row=1, col=1)
fig.add_trace(trace2_3d, row=1, col=1)

# Add 2D plot to the second column
for trace in fig_2d.data:
    fig.add_trace(trace, row=1, col=2)

# Update layout
fig.update_layout(
    title_text="Benchmark Analysis Dashboard",
    legend=dict(x=0.5, xanchor='center'),
    scene=dict(
        xaxis_title='Run Number',
        yaxis_title='Iterations',
        zaxis_title='Runtime (seconds)'
    )
)

# Saving the combined figure to HTML
fig.write_html('benchmark_plots.html')

# Print path to the saved figure
html_file_path_combined = os.path.realpath('benchmark_plots.html')
print(f"The combined plot has been saved to: {html_file_path_combined}")
