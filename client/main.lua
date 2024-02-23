if(GetResourceState('es_extended') == 'missing') then
    return print('es_extended is missing, please ensure it is installed and started, otherwise the script will not work well.')
end

dispatch = {
    open = false,
    cursor = false,
    player = {},
    data = {
        index = 1,
        calls = {},
        channels = {},
        controls = {
            { label = 'RAD', value = 'rad', disabled = false },
            { label = 'C-37', value = 'c-37', disabled = false },
            { label = '320', value = '320', disabled = true },
            { label = 'TEM', value = 'tem', disabled = false },
            { label = 'PANIC', value = 'panic', disabled = true }
        }        
    }
}