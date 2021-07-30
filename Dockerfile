FROM quay.io/openshift/origin-must-gather:4.8.0 as stage1
FROM stage1 as stage2
# Save original gather script
COPY --from=stage1 /usr/bin/gather /usr/bin/gather_original
#COPY --from=builder /usr/bin/oc /usr/bin/oc

RUN mkdir -p /var/lib/node-must-gather

COPY resources/ /var/lib/node-must-gather/

# Copy all collection scripts to /usr/bin
COPY collection-scripts/* /usr/bin/

ENTRYPOINT /usr/bin/gather
