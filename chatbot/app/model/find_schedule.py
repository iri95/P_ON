import dateparser

def parse_user_input(user_input):
    # 현재 날짜를 가져옵니다.
    today = dateparser.parse("today").date()

    # 입력 문자열을 파싱하여 날짜를 계산합니다.
    parsed_date = dateparser.parse(user_input, languages=['ko'])
    if parsed_date:
        calculated_date = parsed_date.date()
        return calculated_date
    else:
        raise ValueError("날짜를 파싱할 수 없습니다.")

# 사용자 입력을 받습니다.
user_input = input("날짜를 입력하세요: ")

try:
    # 사용자 입력을 파싱하여 날짜를 계산합니다.
    result_date = parse_user_input(user_input)
    print("계산된 날짜:", result_date)
except ValueError as e:
    print(e)
