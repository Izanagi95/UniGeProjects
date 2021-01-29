import numpy as np
import matplotlib.pyplot as plt


def fill_first_values(value1, value2, value3):
    list_value1.insert(len(list_value1), value1)
    list_value2.insert(len(list_value2), value2)
    list_value3.insert(len(list_value3), value3)


def fill_last_values(value1, value2, value3):
    list_value4.insert(len(list_value4), value1)
    list_value5.insert(len(list_value5), value2)
    list_value6.insert(len(list_value6), value3)


def plot_all():
    plot_first_half()
    plot_second_half()
    plt.show()


def plot_first_half():
    fig = plt.figure(1)
    ax = fig.add_subplot(111)

    n = 5
    ind = np.arange(n)
    bar_width = 0.2

    # the bars
    bar1 = ax.bar(ind + bar_width, list_value1, bar_width,
                  color='black',
                  # error_kw=dict(elinewidth=2, ecolor='red')
                  )

    bar2 = ax.bar(ind + bar_width * 2, list_value2, bar_width,
                  color='red',
                  # error_kw=dict(elinewidth=2, ecolor='black')
                  )

    bar3 = ax.bar(ind + bar_width * 3, list_value3, bar_width,
                  color='blue',
                  # error_kw=dict(elinewidth=2, ecolor='black')
                  )

    # axes and labels
    ax.set_xlim(-bar_width, len(ind) + bar_width)
    ax.set_ylim(0, 1)
    ax.set_ylabel('Value')
    ax.set_title('Grafico riassuntivo')
    xTickMarks = [str(i) + "%" for i in (0, 5, 10, 50, 100)]
    ax.set_xticks(ind + bar_width * 2)
    xtickNames = ax.set_xticklabels(xTickMarks)
    plt.setp(xtickNames, fontsize=10)
    # add a legend
    ax.legend((bar1[0], bar2[0], bar3[0]), ('Betweeness', 'Closeness', 'Clustering'))


def plot_second_half():
    fig = plt.figure(2)
    ax = fig.add_subplot(111)

    n = 5
    ind = np.arange(n)
    bar_width = 0.2

    # the bars
    bar1 = ax.bar(ind + bar_width, list_value4, bar_width,
                  color='black',
                  # error_kw=dict(elinewidth=2, ecolor='red')
                  )

    bar2 = ax.bar(ind + bar_width * 2, list_value5, bar_width,
                  color='red',
                  # error_kw=dict(elinewidth=2, ecolor='black')
                  )

    bar3 = ax.bar(ind + bar_width * 3, list_value6, bar_width,
                  color='blue',
                  # error_kw=dict(elinewidth=2, ecolor='black')
                  )

    # axes and labels
    ax.set_xlim(-bar_width, len(ind) + bar_width)
    ax.set_ylim(0, 10)
    ax.set_ylabel('Value')
    ax.set_title('Grafico riassuntivo')
    xTickMarks = [str(i) + "%" for i in (0, 5, 10, 50, 100)]
    ax.set_xticks(ind + bar_width * 2)
    xtickNames = ax.set_xticklabels(xTickMarks)
    plt.setp(xtickNames, fontsize=10)
    # add a legend
    ax.legend((bar1[0], bar2[0], bar3[0]), ('Degree', 'Shortest path', 'Diameter'))


def print_list():
    print("values 1: " + str(list_value1))
    print("values 2: " + str(list_value2))
    print("values 3: " + str(list_value3))
    print("values 4: " + str(list_value4))
    print("values 5: " + str(list_value5))
    print("values 6: " + str(list_value6))


list_value1 = []
list_value2 = []
list_value3 = []
list_value4 = []
list_value5 = []
list_value6 = []
