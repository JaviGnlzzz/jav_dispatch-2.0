Shared = {}

Shared.Language = 'en' -- en / es

Language = {}

Shared.Dispatch = {
    Jobs = {
        ['police'] = {

            panic = true,
            
            commands = {
                'entorno',
                'forzar',
                'tem'
            },

            channel = {
                id = 'police_radio',
                title = 'LSPD - Radio',
                allowedJobs = {
                    'police',
                }
            }
        },

        ['ambulance'] = {

            panic = false,

            commands = {
                'auxilio',
            },

            channel = {
                id = 'ambulance_radio',
                title = 'EMS - Radio',
                allowedJobs = {
                    'ambulance',
                    'police'
                }
            }
        }
    }
}