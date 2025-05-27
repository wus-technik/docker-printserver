
# Dockerized CUPS Print Server

This project provides a Docker environment for a CUPS (Common UNIX Printing System) print server. The configuration and policies of the print server can be customized using the provided files.

## @todo
- persistent storage (mounts) debug
- limit UI access to https (proxy ip)

## Features
- CUPS 2.4.2 @2025-05-02
- 

## Directory Structure

- `install/etc/cups/cupsd.conf`: Configuration file for the CUPS server.
- `example/docker-compose.yml`: Example Docker Compose configuration.

## Prerequisites

- Docker
- Docker Compose

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. Adjust the configuration files as needed:
    - `install/etc/cups/cupsd.conf`: Configure access restrictions, policies, and other settings.

3. (Optional) Enable volumes in `docker-compose.yml` to store persistent data:
   ```yaml
   volumes:
     - /var/lib/docker/compose/cups102/config:/etc/cups
     - /var/lib/docker/compose/cups102/spool:/var/spool/cups
     - /var/lib/docker/compose/cups102/log:/var/log/cups
   ```

4. Start the CUPS server:
   ```bash
   docker-compose -f example/docker-compose.yml up -d
   ```

## Usage

- The CUPS server is accessible on port `631`.
- Adjust the policies in `cupsd.conf` to control access and authentication.

## Configuration

### `cupsd.conf`

The `cupsd.conf` file contains the configuration of the CUPS server, including access restrictions and authentication policies. Examples of policies:
- **Default Policy**: Default rules for print jobs and administration.
- **Authenticated Policy**: Authenticated access for print jobs and administration.
- **Kerberos Policy**: Kerberos-based authentication.

## Drivers

### PPD
PPD files are used to define printer capabilities and options.

- `install/usr/share/cups/model`:
  - KMbeuC750iux.ppd: bizhub C750i series (C750i/C650i/C550i/C450i/C360i/C300i/C250i/C287i/C257i/C227i/C286i/C266i/C226i/C4050i/C3350i/C4000i/C3300i/C3320i)
  - Kyocera_TASKalfa_3501i.PPD: TASKalfa 3501i series

## Troubleshooting

- **CUPS not reachable**: Ensure the ports in `docker-compose.yml` are correctly exposed.
- **Access issues**: Check the policies in `cupsd.conf`.

## License

This project is licensed under the [MIT License](LICENSE).
```