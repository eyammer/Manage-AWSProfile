# Manage-AWSProfile

Use `Manage-AWSProfile` to set your current default aws config profile, unset the current default profile, show the current default profile, and list all available profiles.

## Usage

To select the default profile from a list of available profiles use do not pass any flags:

```Powershell
Manage-AWSProfile

Please choose profile:
1: profile-1
2: profile-2
3: profile-3
4: profile-4
Press a number to select a profile: 1

AWS profile set to: 
profile-1

```

If you know the profile you wish to use you can pass it explicitly

```Powershell
Manage-AWSProfile -P <profile-name>
Manage-AWSProfile <profile-name>
Manage-AWSProfile -Profile <profile-name>
```

To unset the current default profile:

```Powershell
Manage-AWSProfile -U
Manage-AWSProfile -Unset
```

To list the available profiles:

```Powershell
Manage-AWSProfile -L
Manage-AWSProfile -List
```

To show the current default profile:

```Powershell
Manage-AWSProfile -C
Manage-AWSProfile -Current
```
