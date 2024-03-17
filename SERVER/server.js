const express = require('express');
const path = require('path');
const mysql = require('mysql2/promise'); // Using promise-based API for cleaner async/await syntax
const bodyParser = require('body-parser');
const multer = require('multer');

// Initialize the Express app
const app = express();
const PORT = process.env.PORT || 3000;


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads');
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});
const upload = multer({ storage: storage });




// Serve static files from the specified directory
app.use('/photos', express.static(path.join(__dirname, 'photos')));
app.use(bodyParser.json());

// Create a MySQL connection pool (using promise-based API)
const pool = mysql.createPool({
  host: 'localhost',
  user: 'hisadmin',
  password: 'pass',
  database: 'hisql', // Change to your database name
});

// Check if the connection pool is connected successfully
pool.getConnection()
  .then(connection => {
    console.log('Connected to MySQL');
    connection.release(); // Release the connection after checking
  })
  .catch(err => {
    console.error('Error connecting to MySQL:', err);
  });

// Define API endpoints

app.get('/api/monuments', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM histab');
    // Convert absolute image paths to relative paths (if applicable)
    const monuments = rows.map(monument => ({
      ...monument,
      imageUrl: monument.image_path ? `/photos/${path.basename(monument.image_path)}` : null, // Handle cases without image paths
    }));
    res.json(monuments);
  } catch (error) {
    console.error('Error fetching monuments:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/monuments/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await pool.query('SELECT * FROM histab WHERE id = ?', [id]);
    if (rows.length === 0) {
      res.status(404).json({ error: 'Monument not found' });
    } else {
      const monument = rows[0];
      if (monument.image_path) {
        // Convert absolute image path to full URL (if applicable)
        monument.imageUrl = `http://172.16.33.173:3000/photos/${path.basename(monument.image_path)}`;
      }
      res.json(monument);
    }
  } catch (error) {
    console.error('Error fetching monument details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get all monument names
app.get('/api/names', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT name FROM histab');
    const names = rows.map(row => row.name);
    res.json(names);
  } catch (error) {
    console.error('Error fetching monument names:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a new monument
// Add a new monument
app.post('/api/monuments', upload.single('image'), async (req, res) => {
  try {
    // Extract data from the request body
    const { name, location, about_monument, location_coordinate } = req.body;
    const image_path = req.file ? req.file.path : null; // Check if an image was uploaded

    // Perform validation (you can add more validation as needed)
    if (!name || !location || !about_monument || !location_coordinate) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Insert the new monument data into the database
    const [result] = await pool.query(
      'INSERT INTO monuments (name, location, about_monument, location_coordinate) VALUES (?, ?, ?, ?)',
      [name, location, about_monument, location_coordinate]
    );

    // Send a success response
    res.status(201).json({ message: 'Monument added successfully', insertedId: result.insertId });
  } catch (error) {
    console.error('Error adding monument:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


app.get('/api/findNearestMonuments', (req, res) => {
    // Extract user's current location and fetch monument locations from the database
    const userLocation = req.query.location; // Assuming location is passed as query parameter
    const monumentLocations = fetchMonumentLocationsFromDatabase(); // Implement this function to fetch monument locations
    
    // Execute Python script
    const pythonProcess = spawn('python', ['nearest_monuments.py', JSON.stringify(userLocation), JSON.stringify(monumentLocations)]);

    // Capture output from Python script
    pythonProcess.stdout.on('data', (data) => {
        const nearestMonuments = JSON.parse(data);
        res.json(nearestMonuments);
    });

    // Handle errors
    pythonProcess.stderr.on('data', (data) => {
        console.error(`Error from Python script: ${data}`);
        res.status(500).json({ error: 'Internal server error' });
    });
});


// Start the server
app.listen(PORT, '172.16.33.173', () => {
  console.log(`Server is running on http://172.16.33.173:${PORT}`);
});
