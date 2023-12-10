Y=[2006	1138	993	1027	1155	1175	1299	1786	1781	1570	1387	1635	2795	1679	1329	1585	1406	1260	1814	1556	2143	1963	1555	1217	1738	1261	1141	1099	1274	1325	1197	1596	1923	1789	1606	2174	3089	1746	1571	1545	1593	1480	1925	1290	2637	1907	1922	1660	2355	1104	1093	1085	1125	1257	1055	1547	1927	1881	1490	2156	3147	1706	1599	1544	1738	1747	2380	2049	2713	2543	2139	2105	2378	1461	1295	1313	1360	1582	1425	1656	1822	1602	1404	1837	2589	1052	956	895	972	1124	1620	1280	1492	1587	1330	1219	2064	1347	1325	1273	1461	1481	1511	2000	2137	1643	1464	1706	2236	1065	994	907	948	997	1788	1394	1787	1435	1225	1221	1900	1259	1357	509	557	1375	1548	1802	1995	1720	1468	1625	2515	1371	1439	1642	1344	1247	1737	1434	1782	1595	1348	1083	1864	1367	1299	1301	1308	1382	1401	1837	2045	1790	1409	1179	1852	796	780	602	584	558	831	639	943	960	859	775	976	581	563	547	635	664	684	828	981	889	1303	1490	2246	1335	1270	1281	1210	1078	1664	1337	1632	1454	1333	1146	1721	1059	963	1000	1107	1132	1086	1399	1575	1507	1469	1650	2305	1328	1323	1314	1317	1443	1963	2201	2577	1900	1606	1390	1859	1009	1001	940	981	1239	1023	1284	1510	1497	1448	1677	2188	1499	1313	1351	1237	1454	2031	1615	2230	1899	1574	1666];
Y=Y(1:168)';
x=1:168;
% 通过AIC，BIC等准则暴力选定阶数
%[AR_Order,MA_Order] = ARMA_Order_Select(Y,max_ar,max_ma,0); 
AR_Order=6;
MA_Order=3;
Mdl = arima(6,0,3);  
EstMdl = estimate(Mdl,Y);
[res,~,logL] = infer(EstMdl,Y);   %res即残差

stdr = res/sqrt(EstMdl.Variance);
figure('Name','残差检验')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)
% 5.预测
step = 24; %预测步数为24
[forData,YMSE] = forecast(EstMdl,step,'Y',Y);   %matlab2018及以下版本写为Predict_Y(i+1) = forecast(EstMdl,1,'Y0',Y(1:i)); 
lower = forData - 1.96*sqrt(YMSE); %95置信区间下限
upper = forData + 1.96*sqrt(YMSE); %95置信区间上限
subplot(2,3,6);
plot(Y,'Color',[.7,.7,.7]);hold on;
h1 = plot(length(Y):length(Y)+step,[Y(end);lower],'r:','LineWidth',2);subplot(2,3,6);
plot(length(Y):length(Y)+step,[Y(end);upper],'r:','LineWidth',2),hold on;
h2 = plot(length(Y):length(Y)+step,[Y(end);forData],'k','LineWidth',2);subplot(2,3,6);
legend([h1 h2],'95% 置信区间','预测值','Location','NorthWest')
title('Forecast')