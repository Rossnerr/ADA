App = {
  loading: false,
  contracts: {},

  load: async () => {
    await App.loadWeb3()
    await App.loadAccount()
    await App.loadContract()
    await App.render()
  },

  // https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
  loadWeb3: async () => {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider
      web3 = new Web3(web3.currentProvider)
    } else {
      window.alert("Please connect to Metamask.")
    }
    // Modern dapp browsers...
    if (window.ethereum) {
      window.web3 = new Web3(ethereum)
      try {
        // Request account access if needed
        await ethereum.enable()
        // Acccounts now exposed
        web3.eth.sendTransaction({/* ... */})
      } catch (error) {
        // User denied account access...
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = web3.currentProvider
      window.web3 = new Web3(web3.currentProvider)
      // Acccounts always exposed
      web3.eth.sendTransaction({/* ... */})
    }
    // Non-dapp browsers...
    else {
      console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  },

  loadAccount: async () => {
    // Set the current blockchain account
    App.account = web3.eth.accounts[0]
    web3.eth.defaultAccount = App.account
  },

  loadContract: async () => {
    // Create a JavaScript version of the smart contract
    const todoList = await $.getJSON('TodoList.json')
    App.contracts.TodoList = TruffleContract(todoList)
    App.contracts.TodoList.setProvider(App.web3Provider)

    // Hydrate the smart contract with values from the blockchain
    App.todoList = await App.contracts.TodoList.deployed()

    
  },

  render: async () => {
    // Prevent double render
    if (App.loading) {
      return
    }

    // Update app loading state
    App.setLoading(true)

    // Render Account
    $('#account').html(App.account)

    $('#todo')
    .on('click', App.markCheckedAs)
    
    $('#doing')
    .on('click', App.markCheckedAs)
    
    $('#testing')
    .on('click', App.markCheckedAs)
    
    $('#done')
    .on('click', App.markCheckedAs)
    
    $('#taskList')
    .css('margin-top', '20px')

    // Render Tasks
    await App.renderTasks()

    // Update loading state
    App.setLoading(false)
  },
  arr: ['To Do', 'Doing', 'Testing', 'Done'],
  colors: ['#a13fb5', '#515ba6', '#99b33e', '#3fb553'],
  markCheckedAs: async (e) => {
      var newState = e.target.innerText;
      var ethState = App.arr.indexOf(newState);
      var checkedIds = $.map($( "input:checked" ), e => e.name);
      checkedIds.forEach(async taskId => {      
        await App.todoList.changeStatus(taskId, ethState)
      });
    window.location.reload()
  },
  renderTasks: async () => {
    // Load the total task count from the blockchain
    const taskCount = await App.todoList.taskCount()
    
    // Render out each task with a new task template
    for (var i = 1; i <= taskCount; i++) {
      // Fetch the task data from the blockchain
      const task = await App.todoList.tasks(i)

      const taskId = task[0].toNumber()
      const taskContent = task[1]
      const taskCompleted = task[2]
      const status = App.arr[task[3]];

      var div = document.createElement("div"); 
      div.className = 'todoTaskTemplate'
      var label = document.createElement('label')
      var input = document.createElement('input')
      input.type = 'checkbox'
      input.name = taskId
      input.checked = taskCompleted
      var span = document.createElement('span')
      span.className = 'content'

      span.append(taskContent)
      label.append(input)
      label.appendChild(span)
      div.append(label)
      
      var list;
      
      switch(status){
        case 'To Do':
          list = document.getElementById('todoTaskList')
          break;
        case 'Doing':
          list = document.getElementById('doingTaskList')          
          break;
        case 'Testing':
          list = document.getElementById('testingTaskList')          
          break;
        case 'Done':
          list = document.getElementById('doneTaskList')
          break;
        default:
          break;
      }

      list.appendChild(div)
    }
  },

  createTask: async () => {
    App.setLoading(true)
    const content = $('#newTask').val()
    await App.todoList.createTask(content)
    window.location.reload()
  },

  setLoading: (boolean) => {
    App.loading = boolean
    const loader = $('#loader')
    const content = $('#content')
    if (boolean) {
      loader.show()
      content.hide()
    } else {
      loader.hide()
      content.show()
    }
  }
}

$(() => {
  $(window).load(() => {
    App.load()
  })
})
