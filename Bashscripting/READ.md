# Deployment of Loreon Web
## Steps taking for deployment
Create a virtual machine on azure  and name it basscripting
create a virtual network

<img width="1422" height="611" alt="Screenshot 2025-10-31 064304" src="https://github.com/user-attachments/assets/ceebd774-1b76-4266-8aa6-52189bc3fe6b" />

Allow port 22 for ssh connections

<img width="1410" height="853" alt="Screenshot 2025-10-31 065852" src="https://github.com/user-attachments/assets/dd1c31ee-3537-4b44-8a3e-f80e9d4af9c0" />

connect to your VM 

<img width="1916" height="782" alt="Screenshot 2025-10-31 071700" src="https://github.com/user-attachments/assets/2fd56007-fc69-4400-a8dd-6a6182bfd0ab" />

Make a directory Called learning
create a file loreon.sh and write your script
vi loreon.sh

<img width="1576" height="943" alt="Screenshot 2025-11-01 031652" src="https://github.com/user-attachments/assets/eb62cb6c-1d09-48bf-ab52-5658f7f41c3a" />

create a file nano .env to save our variable, it should be visiable in the script

<img width="1833" height="931" alt="Screenshot 2025-11-01 031953" src="https://github.com/user-attachments/assets/f924f3ac-55be-4bf0-819b-87b9b396124f" />

modify youe script and excute wiht this
chmod +x loreon.sh
sudo ./loreon.sh

<img width="1730" height="930" alt="Screenshot 2025-10-31 213717" src="https://github.com/user-attachments/assets/6102a874-bdd2-4b41-9775-10851b3a7b8f" />

script running

<img width="1751" height="935" alt="Screenshot 2025-10-31 215853" src="https://github.com/user-attachments/assets/4947b7b5-c1af-4a67-bf35-11554132b248" />

came across with error in line 24 and line 22

<img width="1159" height="310" alt="Screenshot 2025-10-31 215936" src="https://github.com/user-attachments/assets/90823eb1-c27b-41e0-a849-14f696112716" />

Error corrected and runing

<img width="1849" height="916" alt="Screenshot 2025-10-31 221137" src="https://github.com/user-attachments/assets/f25cc249-c4b1-4eab-ac1b-75a1f8cc808d" />

error in line 22 

<img width="1692" height="939" alt="Screenshot 2025-10-31 221504" src="https://github.com/user-attachments/assets/813d1907-7325-4a01-a79e-177142a767f0" />


Deployment Successful

<img width="1653" height="901" alt="Screenshot 2025-10-31 221810" src="https://github.com/user-attachments/assets/feed3e7f-bce3-4d1e-817b-f7d34e50cc37" />


Add port 80 (http) to NSG inbound rule in azure

<img width="1919" height="896" alt="Screenshot 2025-11-01 013900" src="https://github.com/user-attachments/assets/e18145fa-cf75-4443-9ec4-72bf26530728" />

Final result  

<img width="1908" height="925" alt="Screenshot 2025-11-01 015620" src="https://github.com/user-attachments/assets/07a267e4-b004-44d9-a3a4-7dc857233f99" />

Go and check the lod 

<img width="1880" height="550" alt="Screenshot 2025-11-01 033613" src="https://github.com/user-attachments/assets/496c3049-fa6e-40ed-9ea4-e57aad99e53f" />

let
























