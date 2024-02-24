# jav_dispatch-2.0
 Dispatch for Fivem Server


## Preview

![App Screenshot](https://media.discordapp.net/attachments/970447872732573737/1209231842608160891/image.png?ex=65e62be9&is=65d3b6e9&hm=6050aee762d2b2c3682c991324a876c9071a0cf16ce112d218672044fd09b6cf&=&format=webp&quality=lossless)

![App Screenshot](https://cdn.discordapp.com/attachments/970447872732573737/1209231842901889174/image.png?ex=65e62be9&is=65d3b6e9&hm=194895178831c8513ae99011d9da6dfdadcab61292241a02529d3fca065e5237&)

![App Screenshot](https://media.discordapp.net/attachments/970447872732573737/1209231843258535976/image.png?ex=65e62be9&is=65d3b6e9&hm=c6145e566b550eac4309f28a1983f349b1f199a67e988872b017d18cf4d2adf5&=&format=webp&quality=lossless)



## Job examples

```lua
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
```

# Dependencies
 ESX - QB


