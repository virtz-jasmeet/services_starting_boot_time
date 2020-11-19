*** Settings ***
Documentation                  Check & validate which all services are enabled at boot time
Library                        SSHLibrary
Suite Teardown                 Close All Connections


*** Variables ***
@{ALLHOSTS}=           10.189.153.69  10.189.153.70  10.189.153.71  10.189.153.72  10.189.153.73  10.189.153.74  10.189.153.75
@{CONTROLLERS}=     10.189.153.69  10.189.153.70  10.189.153.71
@{COMPUTES}=        10.189.153.72  10.189.153.73  10.189.153.74  10.189.153.75
${USERNAME}         root
${PASSWORD}         STRANGE-EXAMPLE-neither

*** Test Cases ***
Check Enabled Services on Controller Nodes
    [Documentation]			Check Enabled Services on Controller Nodes
    FOR  ${HOST}  IN  @{CONTROLLERS}
        open connection         ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                enabled_services_controller  /root  mode=0660
        SSHLibrary.File Should Exist   /root/enabled_services_controller
        ${output}=              execute command   systemctl list-unit-files | grep -i enabled | sort > /root/enabled_services_controller_local
        SSHLibrary.File Should Exist   /root/enabled_services_controller_local
        ${output}=              execute command   diff -is /root/enabled_services_controller /root/enabled_services_controller_local
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/enabled_services_controller /root/enabled_services_controller_local
        close connection
    END

Check Enabled Services on Compute Nodes
    [Documentation]			Check Enabled Services on Compute Nodes
    FOR  ${HOST}  IN  @{COMPUTES}
        open connection		      ${HOST}
        login                   ${USERNAME}  ${PASSWORD}  False  True
        Put File                enabled_services_compute  /root  mode=0660
        SSHLibrary.File Should Exist   /root/enabled_services_compute
        ${output}=              execute command   systemctl list-unit-files | grep -i enabled | sort > /root/enabled_services_compute_local
        SSHLibrary.File Should Exist   /root/enabled_services_compute_local
        ${output}=              execute command   diff -is /root/enabled_services_compute /root/enabled_services_compute_local
        Run Keyword And Continue On Failure     should contain    ${output}    identical
        execute command         rm -f /root/enabled_services_compute /root/enabled_services_compute_local
        close connection
    END

*** Keywords ***
