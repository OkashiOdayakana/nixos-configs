{ inputs, config, pkgs, lib, ... }:

{
  sops.secrets."iot/mqtt/zigbee2mqtt.yaml" = {
    owner = "zigbee2mqtt";
    group = "zigbee2mqtt";
  };
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "met"
      "radio_browser"
      "mqtt"
      "esphome"
      "ecobee"
      "zha"
      "zeroconf"
      "homekit"
      "homekit_controller"
      "cast"
      "androidtv"
      "androidtv_remote"
      "spotify"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
      automation = "!include automations.yaml";
      homeassistant = {
        external_url = "https://ha.okash.it";
        internal_url = "https://ha.okash.it";
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
    customComponents = with pkgs.home-assistant-custom-components; [
      frigate
    ];
  };


  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true;
      serial = {
        port = "/dev/ttyACM0";
        adapter = "ember";
        baudrate = 230400;
      };
      mqtt = {
        server = "mqtt://localhost:1883";
        user = "zigbee2mqtt";
        password = "!${config.sops.secrets."iot/mqtt/zigbee2mqtt.yaml".path} password";
      };
      frontend.port = 8099;
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {

          homeassistant = {
            acl = [
              "readwrite #"
            ];
            hashedPassword = "$6$arZ0Sf.HKZGgSBRR$/cAB1gB4P9JQzZ6cEnIWbPNlit.PYQsbRTaRmfUsBePOtPN6P/L7TWNMaeFc2YTT904loeC3Xq3Qpdzxgen9Y/==";
          };


          zigbee2mqtt = {
            acl = [
              "readwrite #"
            ];
            hashedPassword = "$7$101$FtWaHugyRAJMlcCa$EAl3OC8Ux/y6fxfSe2aDjvrxnbkP/l/NmJI0bcrHIltXVCcXyjvsuGmTEhLODm7q76o+ofZ/HJnGJGI2Pyi5MQ==";
          };

          frigate = {
            acl = [
              "readwrite #"
            ];
            hashedPassword = "$7$101$f+AM0D7n8gyVkMHs$BzBvGbqhSqm8BS5oz5VE7EdZtLGQabX1a4lyjVqT87tFmO2WBJ+lqOJEABRZQY4CpxNAMkOoQ3ExvMj5zE4UqA==";
          };
        };
      }
    ];
  };
}
