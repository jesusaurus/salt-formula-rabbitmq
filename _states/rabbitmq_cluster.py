""" RabbitMQ Cluster State """

from salt import exceptions, utils

def __virtual__():
    """ Verify RabbitMQ is installed """
    name = 'rabbitmq_cluster'
    try:
        utils.check_or_die('rabbitmqctl')
    except exceptions.CommandNotFoundError:
        name = False
    return name

def joined(nodes, runas='root'):
    """ Join a RabbitMQ Cluster """

    ret = {'name': 'rabbitmq cluster', 'result': None, 'comment': '',
           'changes': {}}

    is_joined = __salt__['rabbitmq_cluster.is_joined'](nodes, runas)

    if __opts__['test']:
        if is_joined:
            ret['comment'] = 'Already joined - Would have done nothing'
        else:
            ret['comment'] = 'Would have joined the RabbitMQ cluster'
        return ret

    if is_joined:
        ret['result'] = True
        ret['comment'] = 'Already joined to the RabbitMQ cluster'
        return ret

    joined = __salt__['rabbitmq_cluster.join'](nodes=nodes, runas=runas)

    if joined:
      ret['result'] = True
      ret['comment'] = 'Successfully joined the RabbitMQ cluster'
      ret['changes']['cluster'] = 'Joined'
      return ret
    else:
      ret['result'] = False
      ret['comment'] = 'Failed to join the RabbitMQ cluster'
      return ret
