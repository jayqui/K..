# K..
export OKCupid profiles to CSV

### Configuration
You will need to add:

* in a new file `config/user_info.rb`, constants `UserInfo::OKC_USERNAME` and `UserInfo::OKC_PASSWORD`, set to your OKCupid username and password. Format:

```
class UserInfo
  OKC_USERNAME = 'myusername'
  OKC_PASSWORD = 'myp@$$w3rD'
end
```

* a list of usernames in `app/screen_names.yml`. Format:

```
- first_user
- second_user
- ...
```

### To Run
```
ruby app/app.rb
```

### Output
Should be a new csv file under `csv_files/:current_month/:current_day.csv`
