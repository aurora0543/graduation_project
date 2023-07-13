import matplotlib.pyplot as plt
graph = 1

if graph == 0:
    year = []
    for i in range(2003, 2020):
        year.append(i)
    city = [102.44, 129.44, 111.02, 90.72, 111.47, 120.79, 127.96, 125.15, 125.37, 120.37, 125.56, 125.78, 128.23, 126.41,
            126.88, 128.88, 129.41]
    village = [110.94, 137.44, 111.74, 105.48, 119.69, 134.16, 152.09, 145.71, 136.68, 135.95, 150.17, 151.91, 153.63,
               158.15, 157.48, 160.19, 158.63]
    plt.plot(year, city, marker='o', label='City')
    plt.plot(year, village, marker='o', label='Village')
    plt.ylim(80, 180)
    plt.xlim(min(year)-1,max(year)+1)
    plt.title('Trends in cardiovascular risk mortality in China',fontsize=14)
    plt.xlabel('Year (years)',fontsize=14)
    plt.ylabel('Death Rate (1/100,000)',fontsize=14)
    plt.legend(loc=4)
    plt.savefig('折线图.svg', format='svg', dpi=150)
    plt.show()

if graph == 1:
    # 数据
    city_reasons = {'Cardiovascular': 43.81,'Injury': 5.67, 'Cancer': 25.97, 'Respiratory disease': 10.83, 'Other': 13.72}
    rural_reasons = {'Cardiovascular': 46.66, 'Injury': 7.45, 'Cancer': 22.96, 'Respiratory disease': 11.24, 'Other': 11.68}
    # 饼状图标签
    labels = list(city_reasons.keys())
    plt.figure(figsize=(6, 3))
    plt.subplots_adjust(left=None,bottom=None,right=None,top=None,wspace=0.15,hspace=0.15)
    # 城市饼状图
    city_sizes = list(city_reasons.values())
    plt.subplot(1, 2, 1)  # 创建子图，1行2列，当前为第1个子图
    plt.pie(city_sizes, labels=None, autopct='%1.1f%%')
    plt.title('City', loc='center',  fontsize=12)
    # 农村饼状图
    rural_sizes = list(rural_reasons.values())
    plt.subplot(1, 2, 2)  # 创建子图，1行2列，当前为第2个子图
    plt.pie(rural_sizes, labels=None, autopct='%1.1f%%')
    plt.title('Rural', loc='center',  fontsize=12)
    # 添加图例
    plt.legend(labels, loc='center left', bbox_to_anchor=(1, 0.5))
    plt.suptitle('Composition of the main causes of mortality \nof diseases in China for 2018', fontsize=12)
    # 显示图形
    plt.tight_layout()
    plt.savefig('饼图.svg', format='svg', dpi=150)
    plt.show()

if graph == 2:
    

