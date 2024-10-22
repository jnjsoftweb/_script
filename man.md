z.bat
-s: 현재 디렉토리
-d: 부모 디렉토리
-e: 'node_modules,.git'


```sh
z.bat -s "C:\JnJ-soft\Projects\internal\jnj-backend" -d "C:\JnJ-soft\Projects\internal\jnj-backend" -e "node_modules,.git"

7-Zip 24.05 (x64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-05-14



Command Line Error:
Incorrect wildcard type marker
r\JnJ-soft\Projects\internal\jnj-backend\node_modules -xr\JnJ-soft\Projects\internal\jnj-backend\.git
Compression failed. Please check the error messages above.


z.bat -s "C:/JnJ-soft/Projects/internal/jnj-backend" -d "C:/JnJ-soft/Projects/internal/j
nj-backend" -e "node_modules"
```




"C:\Program Files\7-Zip\7z.exe" a -tzip "C:\JnJ-soft\Projects\internal\jnj-backend\jnj-backend_backup.zip" "C:\JnJ-soft\Projects\internal\jnj-backend\*" -xr!node_modules -xr!.git