# Install 08-agent-protocol

```bash
./horizon.sh install 08-agent-protocol --dry-run --operator-root /opt/operator
./horizon.sh install 08-agent-protocol --apply --operator-root /opt/operator
# copy /opt/operator/.horizon/HORIZON.rule.md into your harness
./horizon.sh verify 08-agent-protocol --operator-root /opt/operator
```
