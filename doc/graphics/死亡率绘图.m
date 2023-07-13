x= [1990 1995 2001 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018];
y1=[213  230 234 209 184 212 242 255 254 257 252 259 262 265 265 268 275];
y2=[174 170 189 174 177 206 221 265 257 262 255 294 296 298 309 312 322];




figure;
plot(x,y1,'b',x,y2,'r');
ylabel('死亡率/每10万人') 
xlabel('年份/年')
hold on;

markerIndices = 1:17;  % 要添加方形点的索引
plot(x(markerIndices), y1(markerIndices), 's', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
plot(x(markerIndices), y2(markerIndices), 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
hold off;  % 释放图形




