import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TaskService } from './task.service';
import { Task } from './task.model';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  private taskService = inject(TaskService);

  tasks: Task[] = [];
  newTask: Task = {
    title: '',
    description: '',
    completed: false
  };
  editingTask: Task | null = null;

  ngOnInit(): void {
    this.loadTasks();
  }

  loadTasks(): void {
    this.taskService.getTasks().subscribe({
      next: (tasks) => {
        this.tasks = tasks;
      },
      error: (error) => {
        console.error('Error loading tasks:', error);
      }
    });
  }

  createTask(): void {
    if (!this.newTask.title.trim()) {
      return;
    }

    this.taskService.createTask(this.newTask).subscribe({
      next: (task) => {
        this.tasks.unshift(task);
        this.newTask = {
          title: '',
          description: '',
          completed: false
        };
      },
      error: (error) => {
        console.error('Error creating task:', error);
      }
    });
  }

  toggleComplete(task: Task): void {
    if (!task.id) return;

    this.taskService.updateTask(task.id, { completed: !task.completed }).subscribe({
      next: (updatedTask) => {
        const index = this.tasks.findIndex(t => t.id === task.id);
        if (index !== -1) {
          this.tasks[index] = updatedTask;
        }
      },
      error: (error) => {
        console.error('Error updating task:', error);
      }
    });
  }

  startEdit(task: Task): void {
    this.editingTask = { ...task };
  }

  cancelEdit(): void {
    this.editingTask = null;
  }

  saveEdit(): void {
    if (!this.editingTask || !this.editingTask.id || !this.editingTask.title.trim()) {
      return;
    }

    this.taskService.updateTask(this.editingTask.id, this.editingTask).subscribe({
      next: (updatedTask) => {
        const index = this.tasks.findIndex(t => t.id === this.editingTask!.id);
        if (index !== -1) {
          this.tasks[index] = updatedTask;
        }
        this.editingTask = null;
      },
      error: (error) => {
        console.error('Error updating task:', error);
      }
    });
  }

  deleteTask(task: Task): void {
    if (!task.id) return;

    if (!confirm('Are you sure you want to delete this task?')) {
      return;
    }

    this.taskService.deleteTask(task.id).subscribe({
      next: () => {
        this.tasks = this.tasks.filter(t => t.id !== task.id);
      },
      error: (error) => {
        console.error('Error deleting task:', error);
      }
    });
  }

  formatDate(date: string | undefined): string {
    if (!date) return '';
    return new Date(date).toLocaleString();
  }
}
