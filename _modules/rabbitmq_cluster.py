""" RabbitMQ Cluster Module """

import logging
from salt import exceptions, utils

LOG = logging.getLogger(__name__)

def __virtual__():
    """ Verify RabbitMQ is installed. """
    name = 'rabbitmq_cluster'
    try:
        utils.check_or_die('rabbitmqctl')
    except exceptions.CommandNotFoundError:
        name = False
    return name

def is_joined(nodes, runas='root'):
    # Remove myself from the nodes list
    if __grains__['host'] in nodes:
        nodes.remove(__grains__['host'])

    cluster_status = 'rabbitmqctl cluster_status | grep -R "(%s)"' % "|".join(
        nodes)
    code = __salt__['cmd.retcode'](cluster_status, runas=runas)

    return code == 0

def join(nodes, runas='root'):
    """ Join a RabbitMQ Cluster """

    joined = is_joined(nodes, runas)

    if joined:
        return True
    else:
        LOG.info('Joining RabbitMQ Cluster')

        # Stop the RabbitMQ App
        code = __salt__['cmd.retcode']('rabbitmqctl stop_app', runas=runas)

        if code != 0:
            LOG.error('Failed to stop the RabbitMQ app')
            return False

        for node in nodes:
            LOG.info('Attempting to join with %s', node)
            join_ret = _try_join_cluster(node, runas)

            if join_ret:
                # We sucessfully joined to the cluster
                joined = True
                break

        if not joined:
            LOG.error('Failed to join the RabbitMQ cluster')
            return False

        # Start the RabbitMQ App
        code = __salt__['cmd.retcode']('rabbitmqctl start_app', runas=runas)

        if code != 0:
            LOG.error('Joined cluster, but failed to restart the RabbitMQ app')
            return False
        else:
            return True

def _try_join_cluster(node, runas):
    code = __salt__['cmd.retcode']('rabbitmqctl join_cluster rabbit@%s' % node,
                                   runas=runas)

    if code != 0:
        return False

    return True
