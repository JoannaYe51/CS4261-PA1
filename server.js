const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const app = express();

// Use JSON middleware
app.use(express.json());

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/swiftui-auth');

// User schema
const UserSchema = new mongoose.Schema({
    email: { type: String, unique: true, required: true },
    password: { type: String, required: true }
});

const User = mongoose.model('User', UserSchema);

// User Registration Route
app.post('/api/signup', async (req, res) => {
    const { email, password } = req.body;

    // Check if the user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
        return res.status(400).json({ message: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
    const user = new User({ email, password: hashedPassword });
    await user.save();

    res.status(201).json({ message: 'User created successfully' });
});

// User Login Route
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;

    // Find the user
    const user = await User.findOne({ email });
    if (!user) {
        return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Compare the password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
        return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Generate a JWT token
    const token = jwt.sign({ id: user._id, email: user.email }, 'secretkey', { expiresIn: '1h' });

    res.status(200).json({ token });
});

// History schema
const HistorySchema = new mongoose.Schema({
    amount: { type: Number, required: true },
    note: { type: String },
    date: { type: Date, default: Date.now }
});

const History = mongoose.model('History', HistorySchema);

// Save history route
app.post('/api/history', async (req, res) => {
    const { amount, note, date } = req.body;

    // Create new history record
    const history = new History({ amount, note, date: new Date(date * 1000) });
    await history.save();

    res.status(201).json({ message: 'History saved successfully' });
});

// Start server
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
