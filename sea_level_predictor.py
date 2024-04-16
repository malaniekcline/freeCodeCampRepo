import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import linregress

def draw_plot():
    # Read data from file
    df = pd.read_csv('epa-sea-level.csv')

    # Create scatter plot
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.scatter(df['Year'], df['CSIRO Adjusted Sea Level'])

    # Create first line of best fit
    slope, intercept, r_value, p_value, std_err = linregress(df['Year'], df['CSIRO Adjusted Sea Level'])
    x = [i for i in range(1880, 2051)]
    y = [slope * xi + intercept for xi in x]
    ax.plot(x, y)

    # Create second line of best fit
    recent_df = df[df['Year'] >= 2000]
    slope, intercept, r_value, p_value, std_err = linregress(recent_df['Year'], recent_df['CSIRO Adjusted Sea Level'])
    x = [i for i in range(2000, 2051)]
    y = [slope * xi + intercept for xi in x]
    ax.plot(x, y)

    # Add labels and title
    ax.set_title('Rise in Sea Level')
    ax.set_xlabel('Year')
    ax.set_ylabel('Sea Level (inches)')
    
    # Save plot and return data for testing (DO NOT MODIFY)
    plt.savefig('sea_level_plot.png')
    return plt.gca()