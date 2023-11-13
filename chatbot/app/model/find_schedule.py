from datetime import datetime, timedelta

def convert_date(input_str):
    today = datetime.today().date() 
    if input_str == '오늘':
        return today
    elif input_str == '내일':
        return today + timedelta(days=1)
    elif input_str == '모레':
        return today + timedelta(days=2)
    elif '이번 주' in input_str or '이번주' in input_str:
        try:
            weekday = input_str.split(' ')[2]
        except:
            weekday = input_str.split(' ')[1]
        weekday_dict = {'월요일': 0, '화요일': 1, '수요일': 2, '목요일': 3, '금요일': 4, '토요일': 5, '일요일': 6}
        return today + timedelta(days=(weekday_dict[weekday] - today.weekday() + 7) % 7)
    elif '다음 주' in input_str or '다음주' in input_str:
        try:
            weekday = input_str.split(' ')[2]
        except:
            weekday = input_str.split(' ')[1]
        weekday_dict = {'월요일': 0, '화요일': 1, '수요일': 2, '목요일': 3, '금요일': 4, '토요일': 5, '일요일': 6}
        return today + timedelta(days=(weekday_dict[weekday] - today.weekday() + 7) % 7 + 7)
    elif input_str == '이번 주말':
        return (today + timedelta(days=(5 - today.weekday() + 7) % 7), today + timedelta(days=(6 - today.weekday() + 7) % 7))
    else:
        return False
