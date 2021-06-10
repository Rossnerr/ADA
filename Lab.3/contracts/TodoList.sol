pragma solidity ^0.5.0;

contract TodoList {
  uint public taskCount = 0;

  struct Task {
    uint id;
    string content;
    bool completed;
    Status status;
  }
   enum Status {
      todo,
      doing,
      testing,
      done
   }


  mapping(uint => Task) public tasks;

  event TaskCreated(
    uint id,
    string content,
    bool completed
  );

  event TaskCompleted(
    uint id,
    bool completed
  );

  event TaskStatusChanged(
    uint id,
    Status status
  );

  constructor() public {
    createTask("task 1");
    createTask("task 2");
    createTask("task 3");
  }

  function createTask(string memory _content) public {
    taskCount ++;
    tasks[taskCount] = Task(taskCount, _content, false, Status.todo);
    emit TaskCreated(taskCount, _content, false);
  }

  function toggleCompleted(uint _id) public {
    Task memory _task = tasks[_id];
    _task.completed = !_task.completed;
    tasks[_id] = _task;
    emit TaskCompleted(_id, _task.completed);
  }

  function changeStatus(uint _id, Status _status) public {
    Task memory _task = tasks[_id];
    _task.status = _status;
    tasks[_id] = _task;
    emit TaskStatusChanged(_id, _task.status);
  }

}
