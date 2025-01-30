# dbeaver_bookmarks

Erzeugt eine Liste von Lesezeichen für DBeaver.

## Getting Started

Führe `flutter pub run build_runner build` aus, um die generierten Dateien zu erstellen.

## Milestones

### Prototype

- [x] Basic UI
- [x] Add persistence for projects
- [ ] Add single connection configuration to project
- [ ] Add multiple connection configuration to project
- [ ] Add single connection to connection configuration
- [ ] Add multiple connections to connection configuration
- [ ] generate dbeaver json from connection configuration
- [ ] add better error handling
- [ ] add tests
- [ ] add documentation

### Expand feature

- [ ] Add templates for predefined variable-set usable in connections
- [ ] Add templates for list of same variable-set with different values. (results in multiple connections during dbeaver json generation)
- [ ] Add json-file as source for a template (single / multiple sets)
- [ ] Add json-http-response as source for a template (single / multiple sets)
- [ ] Export & Import / Backup & Restore of whole workspace
- [ ] Export & Import of single project / connection configuration (missing template?)
- [ ] Export & Import of single template
