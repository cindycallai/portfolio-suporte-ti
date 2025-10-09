import json


file_path = "/home/pi/sensor/logs/sentinel.log"


def read_logs(log_file_path):
    with open(log_file_path, "r") as file:
        return file.readlines()


def define_status_ranges():
    return {
        '2xx': range(200, 300),
        '4xx': range(400, 500),
        '5xx': range(500, 600)
    }


def count_requests(logs, method, status_range):
    return sum(
        1 for log in logs
        if ('GET' in log or 'POST' in log)
        and ((method + " " in log) if method != '/get_results' and method != '/start_diagnose' else (method in log))
        and int(log[-8: -4]) in status_range
    )


def create_request_analysis(logs, methods, status_ranges):
    analysis_list = []
    for method in methods:
        counts = {f"{status_type}": count_requests(logs, method, status_ranges[status_type]) for status_type in status_ranges}
        total_count = sum(counts.values())
        if total_count != 0:
            analysis = {
                "method": method,
                "count": total_count,
                **counts
            }
            analysis_list.append(analysis)
    return analysis_list


def host_dictionary_creation(log_file_path):
    logs = read_logs(log_file_path)
    methods = ['/get_results', '/show_results', '/update', '/faq', '/download_take', '/cliente', '/download_files', '/stop_diagnose', '/start_diagnose', '/update_ba', '/reboot', '/delete_files']
    status_ranges = define_status_ranges()
    return create_request_analysis(logs, methods, status_ranges)


def sort_analysis_list(analysis_list):
    return sorted(analysis_list, key=lambda x: x['method'])


def print_analysis(analysis_list):
    print(json.dumps(analysis_list, indent=4))


def main(log_file_path):
    analysis_list = host_dictionary_creation(log_file_path)
    sorted_analysis = sort_analysis_list(analysis_list)
    print_analysis(sorted_analysis)


main(file_path)
